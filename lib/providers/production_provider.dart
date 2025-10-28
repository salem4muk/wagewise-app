
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductionRecord {
  String employeeId;
  String canType; // 'كبير' or 'صغير'
  String processType; // 'نفخ' or 'لف'
  int quantity;
  double cost;
  DateTime date;

  ProductionRecord({
    required this.employeeId,
    required this.canType,
    required this.processType,
    required this.quantity,
    required this.cost,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'employeeId': employeeId,
        'canType': canType,
        'processType': processType,
        'quantity': quantity,
        'cost': cost,
        'date': date.toIso8601String(),
      };

  factory ProductionRecord.fromJson(Map<String, dynamic> json) =>
      ProductionRecord(
        employeeId: json['employeeId'],
        canType: json['canType'],
        processType: json['processType'],
        quantity: json['quantity'],
        cost: json['cost'],
        date: DateTime.parse(json['date']),
      );
}

class ProductionProvider with ChangeNotifier {
  List<ProductionRecord> _productionRecords = [];
  static const _prefsKey = 'production_records_v2'; // Use a new key to avoid conflicts

  List<ProductionRecord> get productionRecords => _productionRecords;

  ProductionProvider() {
    loadFromPrefs();
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final recordsString = prefs.getString(_prefsKey);
    if (recordsString != null) {
      final List<dynamic> recordsJson = jsonDecode(recordsString);
      _productionRecords =
          recordsJson.map((json) => ProductionRecord.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final recordsString =
        jsonEncode(_productionRecords.map((record) => record.toJson()).toList());
    await prefs.setString(_prefsKey, recordsString);
  }

  double calculateCost(int quantity, String canType, String processType) {
    double unitPrice = 0;
    if (processType == 'نفخ') {
      if (canType == 'كبير') {
        unitPrice = 3;
      } else { // صغير
        unitPrice = 1;
      }
    } else if (processType == 'لف') {
      if (canType == 'كبير') {
        unitPrice = 2;
      } else { // صغير
        unitPrice = 1;
      }
    }
    // The logic "اذا كان صغير يقوم بضربة على 2" seems to be handled by the price matrix.
    // If a small can has a different quantity calculation, it should be done *before* calling this function.
    // For now, assuming quantity is the final number of units.
    return quantity * unitPrice;
  }

  void addRecord({
    required String employeeId,
    required int quantity,
    required String canType,
    required String processType,
  }) {
    final cost = calculateCost(quantity, canType, processType);
    final newRecord = ProductionRecord(
      employeeId: employeeId,
      canType: canType,
      processType: processType,
      quantity: quantity,
      cost: cost,
      date: DateTime.now(),
    );
    _productionRecords.add(newRecord);
    _saveToPrefs();
    notifyListeners();
  }

  void updateRecord(int index, ProductionRecord record) {
    // Recalculate cost in case logic changes
    final updatedRecord = ProductionRecord(
        employeeId: record.employeeId,
        canType: record.canType,
        processType: record.processType,
        quantity: record.quantity,
        cost: calculateCost(record.quantity, record.canType, record.processType),
        date: record.date);
    _productionRecords[index] = updatedRecord;
    _saveToPrefs();
    notifyListeners();
  }

  void deleteRecord(int index) {
    _productionRecords.removeAt(index);
    _saveToPrefs();
    notifyListeners();
  }

  // Method to get records for a specific employee
  List<ProductionRecord> getRecordsForEmployee(String employeeId) {
    return _productionRecords.where((rec) => rec.employeeId == employeeId).toList();
  }

  // Method to calculate total production cost for an employee
  double getTotalCostForEmployee(String employeeId) {
    return getRecordsForEmployee(employeeId).fold(0.0, (sum, rec) => sum + rec.cost);
  }
}
