import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/cadastro_page.dart';
import 'pages/home_page.dart';
import 'pages/logs_page.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/login',
    debugShowCheckedModeBanner: false,
    routes: {
      '/login': (context) => const LoginPage(),
      '/cadastro': (context) => const CadastroPage(),
      '/home': (context) => const HomePage(),
      '/logs': (context) => const LogsPage(),
    },
  ));
}