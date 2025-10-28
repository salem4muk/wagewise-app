import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductionRecord {
  String operation;
  int canSize;
  double cost;

  ProductionRecord({
    required this.operation,
    required this.canSize,
    required this.cost,
  });

  Map<String, dynamic> toJson() => {
        'operation': operation,
        'can_size': canSize,
        'cost': cost,
      };

  factory ProductionRecord.fromJson(Map<String, dynamic> json) => ProductionRecord(
        operation: json['operation'],
        canSize: json['can_size'],
        cost: json['cost'],
      );
}

class ProductionProvider with ChangeNotifier {
  List<ProductionRecord> _productionRecords = [];
  static const _prefsKey = 'production_records';

  List<ProductionRecord> get productionRecords => _productionRecords;

  ProductionProvider() {
    loadFromPrefs();
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final recordsString = prefs.getString(_prefsKey);
    if (recordsString != null) {
      final List<dynamic> recordsJson = jsonDecode(recordsString);
      _productionRecords = recordsJson.map((json) => ProductionRecord.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final recordsString = jsonEncode(_productionRecords.map((record) => record.toJson()).toList());
    await prefs.setString(_prefsKey, recordsString);
  }

  void addRecord(ProductionRecord record) {
    _productionRecords.add(record);
    _saveToPrefs();
    notifyListeners();
  }

  void updateRecord(int index, ProductionRecord record) {
    _productionRecords[index] = record;
    _saveToPrefs();
    notifyListeners();
  }

  void deleteRecord(int index) {
    _productionRecords.removeAt(index);
    _saveToPrefs();
    notifyListeners();
  }

  double calculateCost(String operation, int canSize) {
    // TODO: Implement actual cost calculation logic
    return canSize * 0.1;
  }
}
