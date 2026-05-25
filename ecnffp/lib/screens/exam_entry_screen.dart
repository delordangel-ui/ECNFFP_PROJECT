import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/candidate_provider.dart';
import '../providers/exam_provider.dart';
import '../providers/auth_provider.dart';
import '../models/app_models.dart';

class ExamEntryScreen extends StatefulWidget {
  final bool isHorsSession;
  const ExamEntryScreen({super.key, required this.isHorsSession});

  @override
  State<ExamEntryScreen> createState() => _ExamEntryScreenState();
}

class _ExamEntryScreenState extends State<ExamEntryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CandidateProvider>(context, listen: false).loadCandidates();
      Provider.of<ExamProvider>(context, listen: false).loadScores();
    });
  }

  @override
  Widget build(BuildContext context) {
    final candidateProv = Provider.of<CandidateProvider>(context);
    final examProv = Provider.of<ExamProvider>(context);
    final authProv = Provider.of<AuthProvider>(context);

    // Apply role-based filtering
    final candidates = candidateProv.candidates.where((c) {
      if (authProv.isAdmin || authProv.isNational) return true;
      if (authProv.currentRole == UserRole.province) return c.provinceName == authProv.currentUserScope;
      if (authProv.currentRole == UserRole.center) return c.center == authProv.currentUserScope;
      return false;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isHorsSession ? 'SAISIE HORS SESSION' : 'SAISIE SESSION ORDINAIRE'),
        backgroundColor: widget.isHorsSession ? Colors.orange : Colors.green,
      ),
      body: ListView.builder(
        itemCount: candidates.length,
        itemBuilder: (context, index) {
          final c = candidates[index];
          final score = examProv.scores[c.id] ?? ExamScore(candidateId: c.id!);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text('${c.lastName} ${c.postName} ${c.firstName}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Code: ${c.studentCode ?? "Non codifié"}'),
              trailing: ElevatedButton(
                onPressed: () => _showScoreDialog(context, c, score, examProv),
                child: const Text('Saisir Notes'),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showScoreDialog(BuildContext context, Candidate c, ExamScore existingScore, ExamProvider prov) {
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final c1 = TextEditingController(text: widget.isHorsSession ? existingScore.redaction?.toString() : existingScore.day1?.toString());
    final c2 = TextEditingController(text: widget.isHorsSession ? existingScore.sipDpo?.toString() : existingScore.day2?.toString());
    final c3 = TextEditingController(text: existingScore.day3?.toString());
    final c4 = TextEditingController(text: existingScore.day4?.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notes pour ${c.lastName}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.isHorsSession
              ? [
                  TextField(controller: c1, decoration: const InputDecoration(labelText: 'Rédaction'), keyboardType: TextInputType.number),
                  TextField(controller: c2, decoration: const InputDecoration(labelText: 'SIP / DPO'), keyboardType: TextInputType.number),
                ]
              : [
                  TextField(controller: c1, decoration: const InputDecoration(labelText: 'Jour 1'), keyboardType: TextInputType.number),
                  TextField(controller: c2, decoration: const InputDecoration(labelText: 'Jour 2'), keyboardType: TextInputType.number),
                  TextField(controller: c3, decoration: const InputDecoration(labelText: 'Jour 3'), keyboardType: TextInputType.number),
                  TextField(controller: c4, decoration: const InputDecoration(labelText: 'Jour 4'), keyboardType: TextInputType.number),
                ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              if (await authProv.isDataLocked()) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Données verrouillées')));
                return;
              }
              final newScore = ExamScore(
                candidateId: c.id!,
                redaction: widget.isHorsSession ? double.tryParse(c1.text) : existingScore.redaction,
                sipDpo: widget.isHorsSession ? double.tryParse(c2.text) : existingScore.sipDpo,
                day1: !widget.isHorsSession ? double.tryParse(c1.text) : existingScore.day1,
                day2: !widget.isHorsSession ? double.tryParse(c2.text) : existingScore.day2,
                day3: !widget.isHorsSession ? double.tryParse(c3.text) : existingScore.day3,
                day4: !widget.isHorsSession ? double.tryParse(c4.text) : existingScore.day4,
              );
              prov.saveScore(newScore);
              Navigator.pop(context);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}
