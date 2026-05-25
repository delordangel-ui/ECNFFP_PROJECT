import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/app_models.dart';

class AdminProvider with ChangeNotifier {
  List<Province> _provinces = [];
  List<Specialty> _specialties = [];
  List<ManagementType> _managementTypes = [];

  List<Province> get provinces => _provinces;
  List<Specialty> get specialties => _specialties;
  List<ManagementType> get managementTypes => _managementTypes;

  Future<void> loadData() async {
    final db = await DatabaseHelper().database;
    final pMap = await db.query('provinces');
    _provinces = pMap.map((m) => Province.fromMap(m)).toList();

    final sMap = await db.query('specialties');
    _specialties = sMap.map((m) => Specialty.fromMap(m)).toList();

    final mMap = await db.query('management_types');
    _managementTypes = mMap.map((m) => ManagementType.fromMap(m)).toList();

    notifyListeners();
  }

  Future<void> addProvince(String name, String code) async {
    final db = await DatabaseHelper().database;
    await db.insert('provinces', {'name': name, 'code': code});
    await loadData();
  }

  Future<void> updateProvince(int id, String name, String code) async {
    final db = await DatabaseHelper().database;
    await db.update('provinces', {'name': name, 'code': code}, where: 'id = ?', whereArgs: [id]);
    await loadData();
  }

  Future<void> deleteProvince(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete('provinces', where: 'id = ?', whereArgs: [id]);
    await loadData();
  }

  Future<void> addSpecialty(String name, String code) async {
    final db = await DatabaseHelper().database;
    await db.insert('specialties', {'name': name, 'code': code});
    await loadData();
  }

  Future<void> deleteSpecialty(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete('specialties', where: 'id = ?', whereArgs: [id]);
    await loadData();
  }

  Future<void> addManagementType(String name, String code) async {
    final db = await DatabaseHelper().database;
    await db.insert('management_types', {'name': name, 'code': code});
    await loadData();
  }

  Future<void> deleteManagementType(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete('management_types', where: 'id = ?', whereArgs: [id]);
    await loadData();
  }
}
