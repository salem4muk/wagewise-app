import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/voucher_provider.dart';

class VoucherManagementScreen extends StatelessWidget {
  const VoucherManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final voucherProvider = Provider.of<VoucherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة سندات الصرف'),
      ),
      body: voucherProvider.vouchers.isEmpty
          ? const Center(
              child: Text('لا توجد سندات صرف حالياً. قم بإضافة سند جديد.'),
            )
          : ListView.builder(
              itemCount: voucherProvider.vouchers.length,
              itemBuilder: (context, index) {
                final voucher = voucherProvider.vouchers[index];
                return ListTile(
                  title: Text('موظف: ${voucher.employeeName}'),
                  subtitle: Text('المبلغ: ${voucher.amount} ريال - النوع: ${voucher.type}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showVoucherDialog(context, voucherProvider, voucher: voucher, index: index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          voucherProvider.deleteVoucher(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showVoucherDialog(context, voucherProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showVoucherDialog(BuildContext context, VoucherProvider voucherProvider, {Voucher? voucher, int? index}) {
    final isEditing = voucher != null;
    final employeeNameController = TextEditingController(text: isEditing ? voucher.employeeName : '');
    final amountController = TextEditingController(text: isEditing ? voucher.amount.toString() : '');
    String? selectedType = isEditing ? voucher.type : null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'تعديل سند صرف' : 'إضافة سند صرف جديد'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: employeeNameController,
                    decoration: const InputDecoration(labelText: 'اسم الموظف'),
                  ),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'المبلغ'),
                    keyboardType: TextInputType.number,
                  ),
                  DropdownButton<String>(
                    value: selectedType,
                    hint: const Text('نوع السند'),
                    items: <String>['سلفة', 'خصم'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedType = newValue;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                final newVoucher = Voucher(
                  employeeName: employeeNameController.text,
                  amount: double.tryParse(amountController.text) ?? 0.0,
                  type: selectedType!,
                );
                if (isEditing) {
                  voucherProvider.updateVoucher(index!, newVoucher);
                } else {
                  voucherProvider.addVoucher(newVoucher);
                }
                Navigator.of(context).pop();
              },
              child: Text(isEditing ? 'حفظ التعديلات' : 'إضافة'),
            ),
          ],
        );
      },
    );
  }
}
