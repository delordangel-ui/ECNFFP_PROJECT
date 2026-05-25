import 'package:flutter/material.dart';
import '../services/database_helper.dart';

enum UserRole { admin, national, province, center, none }

class AuthProvider with ChangeNotifier {
  UserRole _currentRole = UserRole.none;
  String? _currentUserScope; // Province name or Center name

  UserRole get currentRole => _currentRole;
  String? get currentUserScope => _currentUserScope;

  bool get isAdmin => _currentRole == UserRole.admin;
  bool get isNational => _currentRole == UserRole.national || _currentRole == UserRole.admin;

  Future<bool> login(String code) async {
    final db = await DatabaseHelper().database;

    // Helper to check only code
    Future<bool> check(String codeKey) async {
      final codeRes = await db.query('settings', where: 'key = ? AND value = ?', whereArgs: [codeKey, code]);
      return codeRes.isNotEmpty;
    }

    if (await check('code_1012')) {
      _currentRole = UserRole.admin;
    } else if (await check('code_3345')) {
      _currentRole = UserRole.national;
    } else if (await check('code_2597')) {
      _currentRole = UserRole.province;
    } else if (await check('code_8760')) {
      _currentRole = UserRole.center;
    } else {
      return false;
    }

    notifyListeners();
    return true;
  }

  void logout() {
    _currentRole = UserRole.none;
    _currentUserScope = null;
    notifyListeners();
  }

  Future<void> updateCode(String key, String newCode) async {
    final db = await DatabaseHelper().database;
    await db.update('settings', {'value': newCode}, where: 'key = ?', whereArgs: [key]);
  }

  Future<bool> isDataLocked() async {
    final db = await DatabaseHelper().database;
    final res = await db.query('settings', where: 'key = ?', whereArgs: ['data_locked']);
    return res.isNotEmpty && res.first['value'] == '1';
  }

  Future<void> setDataLock(bool lock) async {
    final db = await DatabaseHelper().database;
    await db.update('settings', {'value': lock ? '1' : '0'}, where: 'key = ?', whereArgs: ['data_locked']);
  }
}
