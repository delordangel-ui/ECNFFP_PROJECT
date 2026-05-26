import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'main_dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _codeController = TextEditingController();
  String _errorMessage = '';

  void _handleLogin() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    bool success = await auth.login(_codeController.text);
    if (success) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainDashboard()),
        );
      }
    } else {
      setState(() {
        _errorMessage = 'Code d\'accès invalide';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF003366), Color(0xFF006699)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header / Armoirie
                const Icon(Icons.account_balance, size: 80, color: Colors.white),
                const SizedBox(height: 10),
                const Text(
                  'RÉPUBLIQUE DÉMOCRATIQUE DU CONGO',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
                const Text(
                  'Ministère de la Formation Professionnelle',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const Divider(color: Colors.white24, indent: 50, endIndent: 50, height: 40),
                const Text(
                  'EXAMENS, CONCOURS, TESTS ET CERTIFICATION',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 5),
                const Text(
                  '“Construire l’avenir par les compétences”',
                  style: TextStyle(color: Colors.amber, fontStyle: FontStyle.italic, fontSize: 16),
                ),
                const SizedBox(height: 40),

                // Login Box
                Container(
                  padding: const EdgeInsets.all(30),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'SAISIR LE CODE D\'ACCÈS',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _codeController,
                        obscureText: true,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 10),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black26,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(_errorMessage, style: const TextStyle(color: Colors.redAccent)),
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('ENTRER', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Illustration
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05),
                        border: Border.all(color: Colors.amber.withOpacity(0.3), width: 2),
                      ),
                    ),
                    const Icon(Icons.settings_suggest, size: 120, color: Colors.white24),
                    const Positioned(
                      bottom: 20,
                      child: Column(
                        children: [
                          Icon(Icons.person_pin, size: 80, color: Colors.amber),
                          Text(
                            'FORMATION PROFESSIONNELLE',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'SYSTÈME DE GESTION DES EXAMENS (SGE)',
                  style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
