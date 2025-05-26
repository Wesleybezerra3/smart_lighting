import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController(text: 'Nome do Usuário');
  final TextEditingController _senhaController = TextEditingController();

  bool _editandoNome = false;
  bool _editandoSenha = false;

  String? _validateSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe a nova senha';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil', style: TextStyle(color: Color(0xFFF1F1F1))),
        backgroundColor: const Color(0xFF242424),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF6CF1F)),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
      ),
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
                  const Text('Editar Perfil', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nomeController,
                          enabled: _editandoNome,
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
                            if (_editandoNome && (value == null || value.isEmpty)) {
                              return 'Informe o nome';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      !_editandoNome
                        ? IconButton(
                            icon: const Icon(Icons.edit, color: Color(0xFFF6CF1F)),
                            onPressed: () {
                              setState(() {
                                _editandoNome = true;
                              });
                            },
                          )
                        : IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _editandoNome = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Nome alterado com sucesso!')),
                                );
                              }
                            },
                          ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _senhaController,
                          enabled: _editandoSenha,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Nova Senha',
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
                            if (_editandoSenha) {
                              return _validateSenha(value);
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      !_editandoSenha
                        ? IconButton(
                            icon: const Icon(Icons.edit, color: Color(0xFFF6CF1F)),
                            onPressed: () {
                              setState(() {
                                _editandoSenha = true;
                              });
                            },
                          )
                        : IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _editandoSenha = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Senha alterada com sucesso!')),
                                );
                              }
                            },
                          ),
                    ],
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _editandoNome = false;
                            _editandoSenha = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Perfil atualizado com sucesso!')),
                          );
                        }
                      },
                      child: const Text(
                        'Salvar Alterações',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF242424),
                        ),
                      ),
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
