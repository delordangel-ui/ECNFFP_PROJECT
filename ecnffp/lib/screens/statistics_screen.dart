import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/candidate_provider.dart';
import '../providers/exam_provider.dart';
import '../services/stats_service.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final candidates = Provider.of<CandidateProvider>(context).candidates;
    final scores = Provider.of<ExamProvider>(context).scores;
    final stats = StatsService.getGeneralStats(candidates, scores);

    return Scaffold(
      appBar: AppBar(title: const Text('STATISTIQUES & RAPPORTS'), backgroundColor: Colors.purple, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('INSCRIPTIONS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            _buildStatTile('Total Inscrits', stats['totalInscrits'].toString(), Icons.people, Colors.blue),
            _buildStatTile('Total Femmes', stats['totalFemmes'].toString(), Icons.woman, Colors.pink),

            const SizedBox(height: 20),
            const Text('PARTICIPATION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            _buildStatTile('Participants total', stats['totalParticipants'].toString(), Icons.edit_note, Colors.orange),
            _buildStatTile('Taux Participation Femmes', '${stats['tauxParticipationFemmes'].toStringAsFixed(1)}%', Icons.pie_chart, Colors.orange),

            const SizedBox(height: 20),
            const Text('RÉUSSITE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            _buildStatTile('Total Réussites', stats['totalReussite'].toString(), Icons.check_circle, Colors.green),
            _buildStatTile('Taux de réussite global', '${stats['tauxReussite'].toStringAsFixed(1)}%', Icons.trending_up, Colors.green),

            const SizedBox(height: 20),
            const Text('PAR TYPE D\'ÉTABLISSEMENT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Row(
              children: [
                Expanded(child: _buildStatCard('VAE', stats['totalParticipantsVAE'].toString(), stats['totalFemmesParticipantsVAE'].toString(), Colors.teal)),
                const SizedBox(width: 10),
                Expanded(child: _buildStatCard('TECHNIQUE', stats['totalParticipantsTech'].toString(), stats['totalFemmesParticipantsTech'].toString(), Colors.indigo)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(String label, String value, IconData icon, Color color) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color)),
      ),
    );
  }

  Widget _buildStatCard(String title, String participants, String femmes, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: color)),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 10),
          Text(participants, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Text('Participants', style: TextStyle(fontSize: 10)),
          Text('dont $femmes femmes', style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}
