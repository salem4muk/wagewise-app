import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings page
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                'WageWise',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('لوحة التحكم'),
              onTap: () => context.go('/'),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('إدارة الموظفين'),
              onTap: () => context.go('/employees'),
            ),
            ListTile(
              leading: const Icon(Icons.production_quantity_limits),
              title: const Text('إدارة الإنتاج'),
              onTap: () => context.go('/production'),
            ),
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text('سندات الصرف'),
              onTap: () => context.go('/vouchers'),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('التقارير'),
              onTap: () => context.go('/reports'),
            ),
            ListTile(
              leading: const Icon(Icons.supervised_user_circle),
              title: const Text('إدارة المستخدمين'),
              onTap: () => context.go('/users'),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ملخص سريع',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: const [
                DashboardCard(
                  title: 'إجمالي الرواتب',
                  value: '0',
                  icon: Icons.monetization_on,
                  color: Colors.green,
                ),
                DashboardCard(
                  title: 'عدد الموظفين',
                  value: '0',
                  icon: Icons.people,
                  color: Colors.blue,
                ),
                DashboardCard(
                  title: 'عمليات الإنتاج',
                  value: '0',
                  icon: Icons.production_quantity_limits,
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'آخر سجلات الإنتاج',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            // Placeholder for production records table
            const Center(
              child: Text('لا توجد سجلات إنتاج حالياً'),
            )
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
