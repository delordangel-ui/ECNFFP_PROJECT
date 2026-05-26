import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/candidate_provider.dart';
import '../providers/exam_provider.dart';
import '../models/app_models.dart';

class FinalResultsScreen extends StatefulWidget {
  const FinalResultsScreen({super.key});

  @override
  State<FinalResultsScreen> createState() => _FinalResultsScreenState();
}

class _FinalResultsScreenState extends State<FinalResultsScreen> {
  String _filterProvince = '';
  String _filterSpecialty = '';

  @override
  Widget build(BuildContext context) {
    final candidates = Provider.of<CandidateProvider>(context).candidates;
    final examProv = Provider.of<ExamProvider>(context);

    final filteredCandidates = candidates.where((c) {
      bool pMatch = _filterProvince.isEmpty || c.provinceName == _filterProvince;
      bool sMatch = _filterSpecialty.isEmpty || c.specialtyName == _filterSpecialty;
      return pMatch && sMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('RÉSULTATS À PUBLIER'), backgroundColor: Colors.redAccent),
      body: Column(
        children: [
          _buildFilterBar(candidates),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Nom Complet')),
                  DataColumn(label: Text('Code')),
                  DataColumn(label: Text('Sexe')),
                  DataColumn(label: Text('Province')),
                  DataColumn(label: Text('Pourcentage')),
                  DataColumn(label: Text('Observation')),
                ],
                rows: filteredCandidates.map((c) {
                  final score = examProv.scores[c.id];
                  double perc = score != null ? examProv.calculateFinalPercentage(score) : 0.0;
                  String obs = examProv.getObservation(perc);
                  return DataRow(cells: [
                    DataCell(Text('${c.lastName} ${c.postName} ${c.firstName}')),
                    DataCell(Text(c.studentCode ?? '-')),
                    DataCell(Text(c.gender)),
                    DataCell(Text(c.provinceName)),
                    DataCell(Text('${perc.toStringAsFixed(1)}%')),
                    DataCell(Text(obs, style: TextStyle(color: obs == 'Réussi' ? Colors.green : Colors.red, fontWeight: FontWeight.bold))),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(List<Candidate> candidates) {
    final provinces = candidates.map((c) => c.provinceName).toSet().toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Province'),
              items: [const DropdownMenuItem(value: '', child: Text('Toutes')), ...provinces.map((p) => DropdownMenuItem(value: p, child: Text(p)))],
              onChanged: (v) => setState(() => _filterProvince = v!),
            ),
          ),
          const SizedBox(width: 10),
          // Add Specialty filter if needed
        ],
      ),
    );
  }
}
