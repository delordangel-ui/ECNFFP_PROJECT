import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/app_models.dart';

class CandidateProvider with ChangeNotifier {
  List<Candidate> _candidates = [];
  List<Candidate> _deletedCandidates = [];
  List<Candidate> get candidates => _candidates;
  List<Candidate> get deletedCandidates => _deletedCandidates;

  Future<void> loadCandidates({String? province, String? center}) async {
    final db = await DatabaseHelper().database;
    String query = 'SELECT * FROM candidates WHERE isDeleted = 0';
    List<dynamic> args = [];

    if (province != null) {
      query += ' AND provinceName = ?';
      args.add(province);
    }
    if (center != null) {
      query += ' AND center = ?';
      args.add(center);
    }

    final res = await db.rawQuery(query, args);
    _candidates = res.map((m) => Candidate.fromMap(m)).toList();
    notifyListeners();
  }

  Future<void> loadDeletedCandidates() async {
    final db = await DatabaseHelper().database;
    final res = await db.query('candidates', where: 'isDeleted = 1');
    _deletedCandidates = res.map((m) => Candidate.fromMap(m)).toList();
    notifyListeners();
  }

  Future<int> _getNextOrderNumber(String provinceCode, String centerCode) async {
    final db = await DatabaseHelper().database;
    final res = await db.rawQuery(
      'SELECT MAX(orderNumber) as maxOrder FROM candidates WHERE provinceCode = ? AND centerCode = ?',
      [provinceCode, centerCode]
    );
    int max = (res.first['maxOrder'] as int?) ?? 0;
    return max + 1;
  }

  Future<bool> registerCandidate(Candidate candidate) async {
    final db = await DatabaseHelper().database;

    int nextOrder = await _getNextOrderNumber(candidate.provinceCode, candidate.centerCode);
    final newCandidate = Candidate(
      lastName: candidate.lastName,
      postName: candidate.postName,
      firstName: candidate.firstName,
      birthDate: candidate.birthDate,
      center: candidate.center,
      centerCode: candidate.centerCode,
      school: candidate.school,
      schoolCode: candidate.schoolCode,
      provinceName: candidate.provinceName,
      provinceCode: candidate.provinceCode,
      specialtyName: candidate.specialtyName,
      specialtyCode: candidate.specialtyCode,
      managementTypeName: candidate.managementTypeName,
      managementTypeCode: candidate.managementTypeCode,
      gender: candidate.gender,
      photoPath: candidate.photoPath,
      orderNumber: nextOrder,
    );

    // Check duplicates
    final dup = await db.query('candidates',
      where: 'lastName = ? AND postName = ? AND firstName = ? AND isDeleted = 0',
      whereArgs: [candidate.lastName, candidate.postName, candidate.firstName]
    );

    if (dup.isNotEmpty) return false;

    await db.insert('candidates', newCandidate.toMap());
    await loadCandidates();
    return true;
  }

  String generateStudentCode(Candidate c) {
    // Code = Province + Center + Specialty + School + OrderNumber + ManagementType
    return '${c.provinceCode}${c.centerCode}${c.specialtyCode}${c.schoolCode}${c.orderNumber.toString().padLeft(3, '0')}${c.managementTypeCode}';
  }

  Future<void> codifyCandidate(int id, String code) async {
    final db = await DatabaseHelper().database;
    await db.update('candidates', {'studentCode': code, 'isCodified': 1}, where: 'id = ?', whereArgs: [id]);
    await loadCandidates();
  }

  Future<void> deleteCandidate(int id) async {
    final db = await DatabaseHelper().database;
    await db.update('candidates', {'isDeleted': 1}, where: 'id = ?', whereArgs: [id]);
    await loadCandidates();
    await loadDeletedCandidates();
  }

  Future<void> restoreCandidate(int id) async {
    final db = await DatabaseHelper().database;
    await db.update('candidates', {'isDeleted': 0}, where: 'id = ?', whereArgs: [id]);
    await loadCandidates();
    await loadDeletedCandidates();
  }
}
