import 'package:flutter/material.dart';
import '../services/api_service.dart';


class Usuario {
  final String name;
  final String login;
  final String password;

  Usuario({required this.name, required this.login, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'login': login,
      'password': password,
    };
  }
}

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool _loading = false;

  String? _validateSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe a senha';
    }
    if (value.length <= 3) {
      return 'A senha deve ter mais de 3 caracteres';
    }
    final hasLetter = value.contains(RegExp(r'[A-Za-z]'));
    final hasNumber = value.contains(RegExp(r'[0-9]'));
    if (!hasLetter || !hasNumber) {
      return 'A senha deve conter letras e números';
    }
    return null;
  }

  Future<void> _cadastrar() async {
    if (_formKey.currentState!.validate()) {
      final novoUsuario = Usuario(
        name: _nomeController.text,
        login: _loginController.text,
        password: _senhaController.text,
      );
      setState(() {
        _loading = true;
      });
      try {
        await ApiService.register(
          context,
          'account/register',
          novoUsuario.toJson(),
        );
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao cadastrar'), backgroundColor: Colors.red),
        );
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        color: const Color(0xFF242424),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Crie sua conta', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  const Text('Preencha os campos abaixo', style: TextStyle(fontSize: 18, color: Colors.white)),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _nomeController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      labelStyle: TextStyle(color: Color(0xFFF6CF1F)),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF6CF1F)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF6CF1F), width: 2),
                      ),
                    ),
                    cursorColor: Color(0xFFF6CF1F),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe seu nome';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _loginController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Nome de usuário',
                      labelStyle: TextStyle(color: Color(0xFFF6CF1F)),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF6CF1F)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF6CF1F), width: 2),
                      ),
                    ),
                    cursorColor: Color(0xFFF6CF1F),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o nome de usuário';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _senhaController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      labelStyle: TextStyle(color: Color(0xFFF6CF1F)),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF6CF1F)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF6CF1F), width: 2),
                      ),
                    ),
                    cursorColor: Color(0xFFF6CF1F),
                    validator: _validateSenha,
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
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: _loading ? null : _cadastrar,
                      child: _loading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF242424)),
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
                              'Cadastrar',
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
                        Navigator.pushNamed(context,'/login');
                      },
                      child: const Text('Já tem conta? Faça login', style: TextStyle(color: Color(0xFFF6CF1F))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
