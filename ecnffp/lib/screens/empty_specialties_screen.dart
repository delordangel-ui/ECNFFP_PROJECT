import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class EmptySpecialtiesScreen extends StatelessWidget {
  const EmptySpecialtiesScreen({super.key});

  Future<List<Map<String, dynamic>>> _getEmptySpecialties() async {
    final db = await DatabaseHelper().database;
    // Left join to find specialties without candidates
    return await db.rawQuery('''
      SELECT s.name, s.code
      FROM specialties s
      LEFT JOIN candidates c ON s.name = c.specialtyName AND c.isDeleted = 0
      WHERE c.id IS NULL
    ''');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FILIÈRES SANS CANDIDATS'),
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getEmptySpecialties(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (snapshot.data!.isEmpty) return const Center(child: Text('Toutes les filières ont des candidats.'));

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final s = snapshot.data![index];
              return ListTile(
                leading: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                title: Text(s['name']),
                subtitle: Text('Code: ${s['code']}'),
              );
            },
          );
        },
      ),
    );
  }
}
