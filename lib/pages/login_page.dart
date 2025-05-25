import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF242424),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Bem vindo', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                const Text('Entre com sua conta', style: TextStyle(fontSize: 18, color: Colors.white)),
                const SizedBox(height: 32),
                TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    labelStyle: TextStyle(color: Color(0xFFF6CF1F)),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF6CF1F)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF6CF1F), width: 2),
                    ),
                    focusColor: Color(0xFFF6CF1F),
                  ),
                  cursorColor: Color(0xFFF6CF1F),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    labelStyle: TextStyle(color: Color(0xFFF6CF1F)),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF6CF1F)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF6CF1F), width: 2),
                    ),
                    focusColor: Color(0xFFF6CF1F),
                  ),
                  cursorColor: Color(0xFFF6CF1F),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  height: 48,
                  // decoration: BoxDecoration(
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: Colors.black,
                  //       offset: Offset(4, 6),
                  //       blurRadius: 0,
                  //       spreadRadius: 0,
                  //     ),
                  //   ],
                  // ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF6CF1F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF242424),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/cadastro');
                    },
                    child: const Text('Não tem conta? Cadastre-se', style: TextStyle(color: Color(0xFFF6CF1F))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
