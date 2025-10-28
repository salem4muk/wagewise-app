import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/employee_provider.dart';

class EmployeeManagementScreen extends StatelessWidget {
  const EmployeeManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الموظفين'),
      ),
      body: employeeProvider.employees.isEmpty
          ? const Center(
              child: Text('لا يوجد موظفين حالياً. قم بإضافة موظف جديد.'),
            )
          : ListView.builder(
              itemCount: employeeProvider.employees.length,
              itemBuilder: (context, index) {
                final employee = employeeProvider.employees[index];
                return ListTile(
                  title: Text(employee.name),
                  subtitle: Text('المعرف: ${employee.id} | القسم: ${employee.department}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEmployeeDialog(context, employeeProvider, employee: employee, index: index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          employeeProvider.deleteEmployee(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showEmployeeDialog(context, employeeProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEmployeeDialog(BuildContext context, EmployeeProvider employeeProvider, {Employee? employee, int? index}) {
    final isEditing = employee != null;
    final nameController = TextEditingController(text: isEditing ? employee.name : '');
    final idController = TextEditingController(text: isEditing ? employee.id : '');
    final departmentController = TextEditingController(text: isEditing ? employee.department : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'تعديل موظف' : 'إضافة موظف جديد'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'الاسم'),
              ),
              TextField(
                controller: idController,
                decoration: const InputDecoration(labelText: 'المعرف'),
              ),
              TextField(
                controller: departmentController,
                decoration: const InputDecoration(labelText: 'القسم'),
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
                final newEmployee = Employee(
                  name: nameController.text,
                  id: idController.text,
                  department: departmentController.text,
                );
                if (isEditing) {
                  employeeProvider.updateEmployee(index!, newEmployee);
                } else {
                  employeeProvider.addEmployee(newEmployee);
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
