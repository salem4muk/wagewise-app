import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/employee_provider.dart';
import 'package:myapp/providers/production_provider.dart';
import 'package:myapp/providers/voucher_provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);
    final productionProvider = Provider.of<ProductionProvider>(context);
    final voucherProvider = Provider.of<VoucherProvider>(context);

    final reports = _generateReports(employeeProvider, productionProvider, voucherProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير'),
      ),
      body: reports.isEmpty
          ? const Center(
              child: Text('لا توجد بيانات لعرض التقارير.'),
            )
          : ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'موظف: ${report['employee_name']}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text('إجمالي الإنتاج: ${report['total_production']} ريال'),
                        Text('إجمالي السلف: ${report['total_advances']} ريال'),
                        Text('إجمالي الخصومات: ${report['total_deductions']} ريال'),
                        const Divider(),
                        Text(
                          'صافي الراتب: ${report['net_salary']} ريال',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  List<Map<String, dynamic>> _generateReports(EmployeeProvider employeeProvider, ProductionProvider productionProvider, VoucherProvider voucherProvider) {
    final reports = <Map<String, dynamic>>[];

    for (final employee in employeeProvider.employees) {
      final totalProduction = productionProvider.productionRecords
          .where((record) => record.operation == employee.name) // This logic needs to be adjusted based on how production is recorded
          .fold(0.0, (sum, record) => sum + record.cost);

      final totalAdvances = voucherProvider.vouchers
          .where((voucher) => voucher.employeeName == employee.name && voucher.type == 'سلفة')
          .fold(0.0, (sum, voucher) => sum + voucher.amount);

      final totalDeductions = voucherProvider.vouchers
          .where((voucher) => voucher.employeeName == employee.name && voucher.type == 'خصم')
          .fold(0.0, (sum, voucher) => sum + voucher.amount);

      final netSalary = totalProduction - totalAdvances - totalDeductions;

      reports.add({
        'employee_name': employee.name,
        'total_production': totalProduction,
        'total_advances': totalAdvances,
        'total_deductions': totalDeductions,
        'net_salary': netSalary,
      });
    }

    return reports;
  }
}
