import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'pages/login_page.dart';
import 'pages/cadastro_page.dart';
import 'pages/home_page.dart';
import 'pages/logs_page.dart';
import 'pages/registers_page.dart';
import 'pages/perfil_page.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({Key? key}) : super(key: key);

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final expiry = prefs.getInt('token_expiry');
    final now = DateTime.now().millisecondsSinceEpoch;
    if (token != null && expiry != null && expiry > now) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Remove token se expirado ou não existir
      await prefs.remove('token');
      await prefs.remove('token_expiry');
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => const StartupPage(),
      '/login': (context) => const LoginPage(),
      '/cadastro': (context) => const CadastroPage(),
      '/home': (context) => const HomePage(),
      '/logs': (context) => const LogsPage(),
      '/registers': (context) => const RegistersPage(),
      '/perfil': (context) => const PerfilPage(),
    },
  ));
}

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     initialRoute: '/home', // 👈 Vai direto pra Home
//     routes: {
//       '/': (context) =>
//           const HomePage(), // ou pode deixar StartupPage aqui se quiser
//       // '/login': (context) => const LoginPage(),
//       '/cadastro': (context) => const CadastroPage(),
//       '/home': (context) => const HomePage(),
//       '/logs': (context) => const LogsPage(),
//       '/registers': (context) => const RegistersPage(),
//       '/perfil': (context) => const PerfilPage(),
//     },
//   ));
// }
