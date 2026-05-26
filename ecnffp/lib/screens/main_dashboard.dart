import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'admin_dashboard.dart';
import 'registration_screen.dart';
import 'exam_entry_screen.dart';
import 'statistics_screen.dart';
import 'final_results_screen.dart';
import 'codification_screen.dart';
import 'palmares_screen.dart';
import 'empty_specialties_screen.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TABLEAU DE BORD - ECNFFP'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () => auth.logout(), icon: const Icon(Icons.logout)),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 1.5,
        children: [
          _buildMenuCard(context, 'INSCRIPTIONS', Icons.person_add, Colors.blue, const RegistrationScreen()),
          _buildMenuCard(context, 'CODIFICATION', Icons.qr_code, Colors.indigo, const CodificationScreen()),
          _buildMenuCard(context, 'HORS-SESSION', Icons.assignment, Colors.orange, const ExamEntryScreen(isHorsSession: true)),
          _buildMenuCard(context, 'SESSION ORDINAIRE', Icons.event_note, Colors.green, const ExamEntryScreen(isHorsSession: false)),
          _buildMenuCard(context, 'RÉSULTATS', Icons.list_alt, Colors.teal, const FinalResultsScreen()),
          _buildMenuCard(context, 'PALMARÈS', Icons.emoji_events, Colors.amber, const PalmaresScreen()),
          _buildMenuCard(context, 'STATISTIQUES', Icons.bar_chart, Colors.purple, const StatisticsScreen()),
          _buildMenuCard(context, 'FILIÈRES SANS CANDIDATS', Icons.not_interested, Colors.red, const EmptySpecialtiesScreen()),
          _buildMenuCard(context, 'PARAMÈTRES', Icons.settings, Colors.blueGrey, const AdminDashboard()),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, Color color, Widget destination) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => destination)),
      child: Card(
        color: color.withOpacity(0.1),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: color, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(title)), body: Center(child: Text('Interface $title en développement')));
  }
}
