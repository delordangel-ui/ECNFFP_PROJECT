import 'package:flutter/material.dart';
import '../providers/candidate_provider.dart';
import '../providers/exam_provider.dart';
import '../models/app_models.dart';
import '../services/database_helper.dart';

class StatsService {
  static Map<String, dynamic> getGeneralStats(List<Candidate> candidates, Map<int, ExamScore> scores) {
    int totalInscrits = candidates.length;
    int totalFemmes = candidates.where((c) => c.gender == 'F').length;

    int totalVAE = candidates.where((c) => c.managementTypeName == 'VAE').length;
    int totalFemmesVAE = candidates.where((c) => c.gender == 'F' && c.managementTypeName == 'VAE').length;

    int totalTech = candidates.where((c) => c.managementTypeName != 'VAE').length;
    int totalFemmesTech = candidates.where((c) => c.gender == 'F' && c.managementTypeName != 'VAE').length;

    // Filter participants (those who have at least one score)
    var participants = candidates.where((c) => scores.containsKey(c.id)).toList();
    int totalParticipants = participants.length;
    int totalFemmesParticipants = participants.where((c) => c.gender == 'F').length;

    var participantsVAE = participants.where((c) => c.managementTypeName == 'VAE').toList();
    int totalParticipantsVAE = participantsVAE.length;
    int totalFemmesParticipantsVAE = participantsVAE.where((c) => c.gender == 'F').length;

    var participantsTech = participants.where((c) => c.managementTypeName != 'VAE').toList();
    int totalParticipantsTech = participantsTech.length;
    int totalFemmesParticipantsTech = participantsTech.where((c) => c.gender == 'F').length;

    // Success metrics
    var successList = participants.where((c) => (scores[c.id]!.redaction ?? 0) + (scores[c.id]!.sipDpo ?? 0) + (scores[c.id]!.day1 ?? 0) + (scores[c.id]!.day2 ?? 0) + (scores[c.id]!.day3 ?? 0) + (scores[c.id]!.day4 ?? 0) >= 50).toList();
    int totalReussite = successList.length;
    int totalFemmesReussite = successList.where((c) => c.gender == 'F').length;

    return {
      'totalInscrits': totalInscrits,
      'totalFemmes': totalFemmes,
      'totalVAE': totalVAE,
      'totalFemmesVAE': totalFemmesVAE,
      'totalTech': totalTech,
      'totalFemmesTech': totalFemmesTech,
      'totalParticipants': totalParticipants,
      'totalFemmesParticipants': totalFemmesParticipants,
      'totalParticipantsVAE': totalParticipantsVAE,
      'totalFemmesParticipantsVAE': totalFemmesParticipantsVAE,
      'totalParticipantsTech': totalParticipantsTech,
      'totalFemmesParticipantsTech': totalFemmesParticipantsTech,
      'totalReussite': totalReussite,
      'totalFemmesReussite': totalFemmesReussite,
      'tauxParticipationFemmes': totalParticipants > 0 ? (totalFemmesParticipants / totalParticipants) * 100 : 0,
      'tauxReussite': totalParticipants > 0 ? (totalReussite / totalParticipants) * 100 : 0,
    };
  }

  static List<Candidate> getLaureats(List<Candidate> candidates, ExamProvider examProv) {
    return candidates.where((c) {
      if (!examProv.scores.containsKey(c.id)) return false;
      double perc = examProv.calculateFinalPercentage(examProv.scores[c.id]!);
      return perc >= 65.0;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getDetailedResults() async {
    final db = await DatabaseHelper().database;
    return await db.rawQuery('''
      SELECT c.*, s.redaction, s.sipDpo, s.day1, s.day2, s.day3, s.day4
      FROM candidates c
      JOIN scores s ON c.id = s.candidateId
      WHERE c.isDeleted = 0
    ''');
  }
}
