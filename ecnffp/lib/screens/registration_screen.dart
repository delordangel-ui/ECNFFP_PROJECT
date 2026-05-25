import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/candidate_provider.dart';
import '../providers/admin_provider.dart';
import '../providers/auth_provider.dart';
import '../models/app_models.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _lastNameController = TextEditingController();
  final _postNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _centerController = TextEditingController();
  final _centerCodeController = TextEditingController();
  final _schoolController = TextEditingController();
  final _schoolCodeController = TextEditingController();

  Province? _selectedProvince;
  Specialty? _selectedSpecialty;
  ManagementType? _selectedManagementType;
  String _gender = 'M';
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(leading: const Icon(Icons.camera_alt), title: const Text('Appareil photo'), onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); }),
            ListTile(leading: const Icon(Icons.photo_library), title: const Text('Galerie'), onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); }),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    if (await authProv.isDataLocked()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action impossible: Les données sont verrouillées par l\'administrateur')));
      return;
    }

    if (!_formKey.currentState!.validate() || _selectedProvince == null || _selectedSpecialty == null || _selectedManagementType == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez remplir toutes les informations obligatoires')));
      return;
    }

    final candidate = Candidate(
      lastName: _lastNameController.text,
      postName: _postNameController.text,
      firstName: _firstNameController.text,
      birthDate: _birthDateController.text,
      center: _centerController.text,
      centerCode: _centerCodeController.text,
      school: _schoolController.text,
      schoolCode: _schoolCodeController.text,
      provinceName: _selectedProvince!.name,
      provinceCode: _selectedProvince!.code,
      specialtyName: _selectedSpecialty!.name,
      specialtyCode: _selectedSpecialty!.code,
      managementTypeName: _selectedManagementType!.name,
      managementTypeCode: _selectedManagementType!.code,
      gender: _gender,
      photoPath: _image?.path,
      orderNumber: 1, // Logic to determine order number needed
    );

    final provider = Provider.of<CandidateProvider>(context, listen: false);
    bool success = await provider.registerCandidate(candidate);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Candidat enregistré avec succès')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erreur: Ce candidat existe déjà (Doublon)')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminData = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('INSCRIPTION CANDIDAT')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _showImageSourceActionSheet(context),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null ? const Icon(Icons.camera_alt, size: 40) : null,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(controller: _lastNameController, decoration: const InputDecoration(labelText: 'Nom *'), validator: (v) => v!.isEmpty ? 'Requis' : null),
              TextFormField(controller: _postNameController, decoration: const InputDecoration(labelText: 'Postnom *'), validator: (v) => v!.isEmpty ? 'Requis' : null),
              TextFormField(controller: _firstNameController, decoration: const InputDecoration(labelText: 'Prénom *'), validator: (v) => v!.isEmpty ? 'Requis' : null),

              DropdownButtonFormField<Province>(
                value: _selectedProvince,
                hint: const Text('Province *'),
                items: adminData.provinces.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
                onChanged: (v) => setState(() => _selectedProvince = v),
              ),
              if (_selectedProvince != null)
                 Padding(
                   padding: const EdgeInsets.symmetric(vertical: 8.0),
                   child: Text('Code Province: ${_selectedProvince!.code}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                 ),

              TextFormField(
                controller: _birthDateController,
                decoration: const InputDecoration(labelText: 'Date de naissance (JJ/MM/AAAA) *'),
                validator: (v) => v!.isEmpty ? 'Requis' : null,
              ),
              TextFormField(
                controller: _centerController,
                decoration: const InputDecoration(labelText: 'Centre de formation *'),
                validator: (v) => v!.isEmpty ? 'Requis' : null,
              ),
              TextFormField(
                controller: _centerCodeController,
                decoration: const InputDecoration(labelText: 'Code Centre *'),
                validator: (v) => v!.isEmpty ? 'Requis' : null,
              ),
              TextFormField(
                controller: _schoolController,
                decoration: const InputDecoration(labelText: 'Ecole d\'origine *'),
                validator: (v) => v!.isEmpty ? 'Requis' : null,
              ),
              TextFormField(
                controller: _schoolCodeController,
                decoration: const InputDecoration(labelText: 'Code Ecole *'),
                validator: (v) => v!.isEmpty ? 'Requis' : null,
              ),

              DropdownButtonFormField<Specialty>(
                value: _selectedSpecialty,
                hint: const Text('Spécialité *'),
                items: adminData.specialties.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
                onChanged: (v) => setState(() => _selectedSpecialty = v),
              ),

              DropdownButtonFormField<ManagementType>(
                value: _selectedManagementType,
                hint: const Text('Type de gestion *'),
                items: adminData.managementTypes.map((m) => DropdownMenuItem(value: m, child: Text(m.name))).toList(),
                onChanged: (v) => setState(() => _selectedManagementType = v),
              ),

              const SizedBox(height: 10),
              const Text('Genre *', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Radio<String>(value: 'M', groupValue: _gender, onChanged: (v) => setState(() => _gender = v!)),
                  const Text('M'),
                  const SizedBox(width: 20),
                  Radio<String>(value: 'F', groupValue: _gender, onChanged: (v) => setState(() => _gender = v!)),
                  const Text('F'),
                ],
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.blue[900], foregroundColor: Colors.white),
                child: const Text('ENREGISTRER'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
