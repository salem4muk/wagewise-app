import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/production_provider.dart';

class ProductionManagementScreen extends StatelessWidget {
  const ProductionManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productionProvider = Provider.of<ProductionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الإنتاج'),
      ),
      body: productionProvider.productionRecords.isEmpty
          ? const Center(
              child: Text('لا توجد سجلات إنتاج حالياً. قم بإضافة سجل جديد.'),
            )
          : ListView.builder(
              itemCount: productionProvider.productionRecords.length,
              itemBuilder: (context, index) {
                final record = productionProvider.productionRecords[index];
                return ListTile(
                  title: Text('عملية: ${record.operation} - علبة: ${record.canSize} مل'),
                  subtitle: Text('التكلفة: ${record.cost} ريال'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showProductionDialog(context, productionProvider, record: record, index: index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          productionProvider.deleteRecord(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showProductionDialog(context, productionProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showProductionDialog(BuildContext context, ProductionProvider productionProvider, {ProductionRecord? record, int? index}) {
    final isEditing = record != null;
    final operationController = TextEditingController(text: isEditing ? record.operation : '');
    final canSizeController = TextEditingController(text: isEditing ? record.canSize.toString() : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'تعديل سجل إنتاج' : 'إضافة سجل إنتاج جديد'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: operationController,
                decoration: const InputDecoration(labelText: 'نوع العملية'),
              ),
              TextField(
                controller: canSizeController,
                decoration: const InputDecoration(labelText: 'حجم العلبة (مل)'),
                keyboardType: TextInputType.number,
              ),
            ],
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
                final newRecord = ProductionRecord(
                  operation: operationController.text,
                  canSize: int.tryParse(canSizeController.text) ?? 0,
                  cost: productionProvider.calculateCost(operationController.text, int.tryParse(canSizeController.text) ?? 0),
                );
                if (isEditing) {
                  productionProvider.updateRecord(index!, newRecord);
                } else {
                  productionProvider.addRecord(newRecord);
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
