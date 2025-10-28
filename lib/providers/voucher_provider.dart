import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Voucher {
  String employeeName;
  double amount;
  String type;

  Voucher({
    required this.employeeName,
    required this.amount,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'employee_name': employeeName,
        'amount': amount,
        'type': type,
      };

  factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
        employeeName: json['employee_name'],
        amount: json['amount'],
        type: json['type'],
      );
}

class VoucherProvider with ChangeNotifier {
  List<Voucher> _vouchers = [];
  static const _prefsKey = 'vouchers';

  List<Voucher> get vouchers => _vouchers;

  VoucherProvider() {
    loadFromPrefs();
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final vouchersString = prefs.getString(_prefsKey);
    if (vouchersString != null) {
      final List<dynamic> vouchersJson = jsonDecode(vouchersString);
      _vouchers = vouchersJson.map((json) => Voucher.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final vouchersString = jsonEncode(_vouchers.map((voucher) => voucher.toJson()).toList());
    await prefs.setString(_prefsKey, vouchersString);
  }

  void addVoucher(Voucher voucher) {
    _vouchers.add(voucher);
    _saveToPrefs();
    notifyListeners();
  }

  void updateVoucher(int index, Voucher voucher) {
    _vouchers[index] = voucher;
    _saveToPrefs();
    notifyListeners();
  }

  void deleteVoucher(int index) {
    _vouchers.removeAt(index);
    _saveToPrefs();
    notifyListeners();
  }
}
