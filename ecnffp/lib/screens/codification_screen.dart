import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/candidate_provider.dart';
import '../models/app_models.dart';

class CodificationScreen extends StatelessWidget {
  const CodificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CODIFICATION DES CANDIDATS'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Consumer<CandidateProvider>(
        builder: (context, provider, child) {
          final uncodified = provider.candidates.where((c) => c.studentCode == null).toList();
          final codified = provider.candidates.where((c) => c.studentCode != null).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: uncodified.isEmpty ? null : () => _showCodifyDialog(context, provider, uncodified),
                  icon: const Icon(Icons.qr_code),
                  label: Text('CODIFIER TOUS (${uncodified.length})'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.candidates.length,
                  itemBuilder: (context, index) {
                    final c = provider.candidates[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text(c.lastName[0])),
                      title: Text('${c.lastName} ${c.postName} ${c.firstName}'),
                      subtitle: Text(c.studentCode ?? 'Non codifié'),
                      trailing: c.studentCode == null
                        ? IconButton(
                            icon: const Icon(Icons.auto_fix_high, color: Colors.blue),
                            onPressed: () => provider.codifyCandidate(c.id!, provider.generateStudentCode(c)),
                          )
                        : const Icon(Icons.check_circle, color: Colors.green),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCodifyDialog(BuildContext context, CandidateProvider provider, List<Candidate> candidates) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer la codification'),
        content: Text('Voulez-vous générer les codes pour ${candidates.length} candidats ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('ANNULER')),
          TextButton(
            onPressed: () {
              for (var c in candidates) {
                provider.codifyCandidate(c.id!, provider.generateStudentCode(c));
              }
              Navigator.pop(ctx);
            },
            child: const Text('CONFIRMER')
          ),
        ],
      ),
    );
  }
}
