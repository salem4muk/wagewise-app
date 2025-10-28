
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/production_provider.dart';
import 'package:myapp/providers/employee_provider.dart';

class ProductionManagementScreen extends StatelessWidget {
  const ProductionManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productionProvider = Provider.of<ProductionProvider>(context);
    final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
    final records = productionProvider.productionRecords;

    // Create a map for quick lookup of employee names by ID
    final employeeNameMap = {
      for (var emp in employeeProvider.employees) emp.id: emp.name
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الإنتاج'),
      ),
      body: records.isEmpty
          ? const Center(
              child: Text('لا توجد سجلات إنتاج حالياً. قم بإضافة سجل جديد.'),
            )
          : ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                final employeeName = employeeNameMap[record.employeeId] ?? 'موظف غير معروف';
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(
                        '$employeeName - $employeeNameMap'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'العملية: ${record.processType} | العلبة: ${record.canType} | الكمية: ${record.quantity}'),
                        Text(
                            'التاريخ: ${DateFormat('yyyy-MM-dd').format(record.date)}'),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${record.cost.toStringAsFixed(2)} ريال',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Edit button is complex with this model, omitting for now to focus on add/delete
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () {
                                // Confirmation Dialog
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('تأكيد الحذف'),
                                    content: const Text('هل أنت متأكد من رغبتك في حذف هذا السجل؟'),
                                    actions: [
                                      TextButton(
                                        child: const Text('إلغاء'),
                                        onPressed: () => Navigator.of(ctx).pop(),
                                      ),
                                      TextButton(
                                        child: const Text('حذف', style: TextStyle(color: Colors.redAccent)),
                                        onPressed: () {
                                          productionProvider.deleteRecord(index);
                                          Navigator.of(ctx).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showProductionDialog(context, productionProvider, employeeProvider);
        },
        child: const Icon(Icons.add),
        tooltip: 'إضافة سجل إنتاج',
      ),
    );
  }

  void _showProductionDialog(BuildContext context, ProductionProvider productionProvider, EmployeeProvider employeeProvider) {
    final formKey = GlobalKey<FormState>();
    String? selectedEmployeeId;
    String canType = 'كبير';
    String processType = 'نفخ';
    final quantityController = TextEditingController();

    if (employeeProvider.employees.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('يجب إضافة موظفين أولاً قبل تسجيل الإنتاج.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('إضافة سجل إنتاج جديد'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'اختر الموظف'),
                      value: selectedEmployeeId,
                      items: employeeProvider.employees.map((employee) {
                        return DropdownMenuItem(
                          value: employee.id,
                          child: Text(employee.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedEmployeeId = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'يرجى اختيار موظف' : null,
                    ),
                    TextFormField(
                      controller: quantityController,
                      decoration: const InputDecoration(labelText: 'الكمية (عدد العلب)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال الكمية';
                        }
                        if (int.tryParse(value) == null ||
                            int.parse(value) <= 0) {
                          return 'الرجاء إدخال رقم صحيح أكبر من صفر';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'نوع العلبة'),
                      value: canType,
                      items: ['كبير', 'صغير'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            canType = value;
                          });
                        }
                      },
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'نوع العملية'),
                      value: processType,
                      items: ['نفخ', 'لف'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            processType = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  productionProvider.addRecord(
                    employeeId: selectedEmployeeId!,
                    quantity: int.parse(quantityController.text),
                    canType: canType,
                    processType: processType,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('إضافة'),
            ),
          ],
        );
      },
    );
  }
}
