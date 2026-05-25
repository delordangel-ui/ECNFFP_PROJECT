import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import '../providers/auth_provider.dart';
import '../models/app_models.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<AdminProvider>(context, listen: false).loadData());
  }

  @override
  Widget build(BuildContext context) {
    final adminProv = Provider.of<AdminProvider>(context);
    final authProv = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PARAMÈTRES ET ADMINISTRATION', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildEntitySection('PROVINCES', Icons.map, adminProv.provinces,
            (name, code) => adminProv.addProvince(name, code),
            (id) => adminProv.deleteProvince(id)),

          _buildEntitySection('FILIÈRES', Icons.school, adminProv.specialties,
            (name, code) => adminProv.addSpecialty(name, code),
            (id) => adminProv.deleteSpecialty(id)),

          _buildEntitySection('TYPES DE GESTION', Icons.business, adminProv.managementTypes,
            (name, code) => adminProv.addManagementType(name, code),
            (id) => adminProv.deleteManagementType(id)),

          const Divider(height: 40),
          const Text('SÉCURITÉ & ACCÈS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ListTile(
            leading: const Icon(Icons.key, color: Colors.orange),
            title: const Text('Modifier les codes d\'accès'),
            onTap: () => _showPasswordManagement(context, authProv),
          ),
          FutureBuilder<bool>(
            future: authProv.isDataLocked(),
            builder: (context, snapshot) {
              bool locked = snapshot.data ?? false;
              return SwitchListTile(
                title: const Text('VERROUILLER LES DONNÉES', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                subtitle: const Text('Bloque toute modification par les utilisateurs'),
                value: locked,
                onChanged: (val) async {
                  await authProv.setDataLock(val);
                  setState(() {});
                },
                secondary: Icon(locked ? Icons.lock : Icons.lock_open, color: Colors.red),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEntitySection(String title, IconData icon, List<dynamic> items, Function(String, String) onAdd, Function(int) onDelete) {
    return ExpansionTile(
      leading: Icon(icon, color: Colors.blue[900]),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('${items.length} éléments'),
      trailing: IconButton(icon: const Icon(Icons.add_circle, color: Colors.green), onPressed: () => _showAddDialog(context, title, onAdd)),
      children: items.map((item) => ListTile(
        title: Text(item.name),
        subtitle: Text('Code: ${item.code}'),
        trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => onDelete(item.id)),
      )).toList(),
    );
  }

  void _showAddDialog(BuildContext context, String title, Function(String, String) onSave) {
    final nameController = TextEditingController();
    final codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ajouter $title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nom')),
            TextField(controller: codeController, decoration: const InputDecoration(labelText: 'Code')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(onPressed: () { onSave(nameController.text, codeController.text); Navigator.pop(context); }, child: const Text('Enregistrer')),
        ],
      ),
    );
  }

  void _showPasswordManagement(BuildContext context, AuthProvider auth) {
    final codeControllers = {
      'Admin (actuel: 1012)': TextEditingController(),
      'National (actuel: 3345)': TextEditingController(),
      'Province (actuel: 2597)': TextEditingController(),
      'Centre (actuel: 8760)': TextEditingController(),
    };
    final keys = ['code_1012', 'code_3345', 'code_2597', 'code_8760'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier les codes d\'accès'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: codeControllers.entries.map((e) => TextField(
              controller: e.value,
              decoration: InputDecoration(labelText: 'Nouveau code ${e.key}'),
              keyboardType: TextInputType.number,
            )).toList(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              int i = 0;
              for (var controller in codeControllers.values) {
                if (controller.text.isNotEmpty) {
                  await auth.updateCode(keys[i], controller.text);
                }
                i++;
              }
              Navigator.pop(context);
            },
            child: const Text('Mettre à jour'),
          ),
        ],
      ),
    );
  }
}
