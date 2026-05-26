import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/candidate_provider.dart';

class TrashScreen extends StatelessWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RÉPERTOIRE DES SUPPRESSIONS'),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder(
        future: Provider.of<CandidateProvider>(context, listen: false).loadDeletedCandidates(),
        builder: (context, snapshot) {
          final deleted = Provider.of<CandidateProvider>(context).deletedCandidates;
          if (deleted.isEmpty) return const Center(child: Text('Aucun candidat supprimé'));

          return ListView.builder(
            itemCount: deleted.length,
            itemBuilder: (context, index) {
              final c = deleted[index];
              return ListTile(
                title: Text('${c.lastName} ${c.postName} ${c.firstName}'),
                subtitle: Text('Province: ${c.provinceName}'),
                trailing: IconButton(
                  icon: const Icon(Icons.restore, color: Colors.green),
                  onPressed: () => Provider.of<CandidateProvider>(context, listen: false).restoreCandidate(c.id!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
