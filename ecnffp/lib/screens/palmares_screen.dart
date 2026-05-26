import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/stats_service.dart';

class PalmaresScreen extends StatelessWidget {
  const PalmaresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PALMARÈS (RÉUSSITES ≥ 65%)'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: StatsService().getDetailedResults(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final laureates = snapshot.data!.where((c) {
            double total = (c['redaction'] ?? 0) + (c['sipDpo'] ?? 0) +
                           (c['day1'] ?? 0) + (c['day2'] ?? 0) +
                           (c['day3'] ?? 0) + (c['day4'] ?? 0);
            return total >= 65.0;
          }).toList();

          if (laureates.isEmpty) return const Center(child: Text('Aucun lauréat trouvé (Score < 65%)'));

          return ListView.builder(
            itemCount: laureates.length,
            itemBuilder: (context, index) {
              final c = laureates[index];
              double total = (c['redaction'] ?? 0) + (c['sipDpo'] ?? 0) +
                           (c['day1'] ?? 0) + (c['day2'] ?? 0) +
                           (c['day3'] ?? 0) + (c['day4'] ?? 0);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const Icon(Icons.stars, color: Colors.amber),
                  title: Text('${c['lastName']} ${c['postName']} ${c['firstName']}'),
                  subtitle: Text('Spécialité: ${c['specialtyName']}'),
                  trailing: Text('${total.toStringAsFixed(1)}%',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 18)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
