import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Employee {
  String name;
  String id;
  String department;

  Employee({
    required this.name,
    required this.id,
    required this.department,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'department': department,
      };

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        name: json['name'],
        id: json['id'],
        department: json['department'],
      );
}

class EmployeeProvider with ChangeNotifier {
  List<Employee> _employees = [];
  static const _prefsKey = 'employees';

  List<Employee> get employees => _employees;

  EmployeeProvider() {
    loadFromPrefs();
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final employeesString = prefs.getString(_prefsKey);
    if (employeesString != null) {
      final List<dynamic> employeesJson = jsonDecode(employeesString);
      _employees = employeesJson.map((json) => Employee.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final employeesString = jsonEncode(_employees.map((employee) => employee.toJson()).toList());
    await prefs.setString(_prefsKey, employeesString);
  }

  void addEmployee(Employee employee) {
    _employees.add(employee);
    _saveToPrefs();
    notifyListeners();
  }

  void updateEmployee(int index, Employee employee) {
    _employees[index] = employee;
    _saveToPrefs();
    notifyListeners();
  }

  void deleteEmployee(int index) {
    _employees.removeAt(index);
    _saveToPrefs();
    notifyListeners();
  }
}
