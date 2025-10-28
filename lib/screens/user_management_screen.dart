import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/user_provider.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المستخدمين'),
      ),
      body: userProvider.users.isEmpty
          ? const Center(
              child: Text('لا يوجد مستخدمين حالياً. قم بإضافة مستخدم جديد.'),
            )
          : ListView.builder(
              itemCount: userProvider.users.length,
              itemBuilder: (context, index) {
                final user = userProvider.users[index];
                return ListTile(
                  title: Text(user.username),
                  subtitle: Text('الصلاحية: ${user.role}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showUserDialog(context, userProvider, user: user, index: index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          userProvider.deleteUser(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showUserDialog(context, userProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showUserDialog(BuildContext context, UserProvider userProvider, {User? user, int? index}) {
    final isEditing = user != null;
    final usernameController = TextEditingController(text: isEditing ? user.username : '');
    final passwordController = TextEditingController(); // Always empty for security
    String? selectedRole = isEditing ? user.role : null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'تعديل مستخدم' : 'إضافة مستخدم جديد'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: 'اسم المستخدم'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'كلمة المرور'),
                    obscureText: true,
                  ),
                  DropdownButton<String>(
                    value: selectedRole,
                    hint: const Text('الصلاحية'),
                    items: <String>['مشرف', 'مدير'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRole = newValue;
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
                final newUser = User(
                  username: usernameController.text,
                  role: selectedRole!,
                );
                if (isEditing) {
                  userProvider.updateUser(index!, newUser);
                } else {
                  userProvider.addUser(newUser);
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
