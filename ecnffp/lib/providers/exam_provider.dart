import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/app_models.dart';

class ExamProvider with ChangeNotifier {
  Map<int, ExamScore> _scores = {}; // CandidateID -> Score
  Map<int, ExamScore> get scores => _scores;

  Future<void> loadScores() async {
    final db = await DatabaseHelper().database;
    final res = await db.query('scores');
    _scores = { for (var m in res) m['candidateId'] as int : ExamScore.fromMap(m) };
    notifyListeners();
  }

  Future<void> saveScore(ExamScore score) async {
    final db = await DatabaseHelper().database;
    final existing = await db.query('scores', where: 'candidateId = ?', whereArgs: [score.candidateId]);

    if (existing.isEmpty) {
      await db.insert('scores', score.toMap());
    } else {
      await db.update('scores', score.toMap(), where: 'candidateId = ?', whereArgs: [score.candidateId]);
    }
    await loadScores();
  }

  double calculateFinalPercentage(ExamScore score) {
    double horsSession = (score.redaction ?? 0) + (score.sipDpo ?? 0);
    double sessionOrdinaire = (score.day1 ?? 0) + (score.day2 ?? 0) + (score.day3 ?? 0) + (score.day4 ?? 0);
    double total = horsSession + sessionOrdinaire;
    // Assuming max points is 100 for simplicity in this example
    return total;
  }

  String getObservation(double percentage) {
    if (percentage >= 50) return 'Réussi';
    if (percentage > 0) return 'Échoué';
    return 'Non Présenté';
  }
}
