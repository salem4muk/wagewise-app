import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// Screens
import 'package:myapp/screens/dashboard_screen.dart';
import 'package:myapp/screens/employee_management_screen.dart';
import 'package:myapp/screens/production_management_screen.dart';
import 'package:myapp/screens/voucher_management_screen.dart';
import 'package:myapp/screens/reports_screen.dart';
import 'package:myapp/screens/user_management_screen.dart';

// Providers
import 'package:myapp/providers/production_provider.dart';
import 'package:myapp/providers/employee_provider.dart';
import 'package:myapp/providers/voucher_provider.dart';
import 'package:myapp/providers/user_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => ProductionProvider()),
        ChangeNotifierProvider(create: (context) => EmployeeProvider()),
        ChangeNotifierProvider(create: (context) => VoucherProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const WageWiseApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class WageWiseApp extends StatelessWidget {
  const WageWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primarySeedColor = Colors.teal;

    final TextTheme appTextTheme = TextTheme(
      displayLarge: GoogleFonts.cairo(fontSize: 57, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.w500),
      bodyMedium: GoogleFonts.cairo(fontSize: 14),
    );

    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.light,
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: primarySeedColor,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );

    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.dark,
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );

    return MaterialApp.router(
      title: 'WageWise',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const DashboardScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'employees',
          builder: (BuildContext context, GoRouterState state) {
            return const EmployeeManagementScreen();
          },
        ),
        GoRoute(
          path: 'production',
          builder: (BuildContext context, GoRouterState state) {
            return const ProductionManagementScreen();
          },
        ),
        GoRoute(
          path: 'vouchers',
          builder: (BuildContext context, GoRouterState state) {
            return const VoucherManagementScreen();
          },
        ),
        GoRoute(
          path: 'reports',
          builder: (BuildContext context, GoRouterState state) {
            return const ReportsScreen();
          },
        ),
        GoRoute(
          path: 'users',
          builder: (BuildContext context, GoRouterState state) {
            return const UserManagementScreen();
          },
        ),
      ],
    ),
  ],
);
