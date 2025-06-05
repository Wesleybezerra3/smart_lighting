import 'package:flutter/material.dart';
import 'package:smart_lighting/services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  void _login() async {
    setState(() {
      _loading = true;
    });
    try {
      await ApiService.login('account/login', {
        'login': _usernameController.text.trim(),
        'password': _passwordController.text.trim(),
      });
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário ou senha inválidos'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

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
                const Text(
                  'Bem vindo',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Entre com sua conta',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _usernameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Nome de usuário',
                    labelStyle: TextStyle(color: Color(0xFFF6CF1F)),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF6CF1F)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFF6CF1F),
                        width: 2,
                      ),
                    ),
                    focusColor: Color(0xFFF6CF1F),
                  ),
                  cursorColor: Color(0xFFF6CF1F),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
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
                      borderSide: BorderSide(
                        color: Color(0xFFF6CF1F),
                        width: 2,
                      ),
                    ),
                    focusColor: Color(0xFFF6CF1F),
                  ),
                  cursorColor: Color(0xFFF6CF1F),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  height: 48,
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
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacementNamed(context, '/home');
                      });
                    },
                    // _loading ? null : _login,
                    // child:  _loading
                    //      ? const SizedBox(
                    //          width: 24,
                    //          height: 24,
                    //         child: CircularProgressIndicator(
                    //            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF6CF1F)),
                    //            strokeWidth: 3,
                    //          ),
                    //        )
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
                    child: const Text(
                      'Não tem conta? Cadastre-se',
                      style: TextStyle(color: Color(0xFFF6CF1F)),
                    ),
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
