import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_lighting/services/api_service.dart';
import '../services/api_service.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  var name;
  late TextEditingController _nomeController;
  final TextEditingController _senhaAntigaController = TextEditingController();
  final TextEditingController _novaSenhaController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    getNameUser();
  }

  void getNameUser() async {
    final prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('nome');
    print(storedName);
    if (storedName != null) {
      setState(() {
        name = storedName;
        _nomeController.text = name!;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool _editandoNome = false;
  bool _editandoSenha = false;

  String? _validateSenhaAntiga(String? value) {
    if (!_editandoSenha) return null; // Não valida se não estiver editando
    if (value == null || value.isEmpty) {
      return 'Informe a senha atual';
    }
    return null;
  }

  String? _validateNovaSenha(String? value) {
    if (!_editandoSenha) return null; // Não valida se não estiver editando
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
        title: const Text('Meu Perfil',
            style: TextStyle(color: Color(0xFFF1F1F1))),
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
                  const Text('Editar Perfil',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
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
                              borderSide: BorderSide(
                                  color: Color(0xFFF6CF1F), width: 2),
                            ),
                          ),
                          cursorColor: Color(0xFFF6CF1F),
                          validator: (value) {
                            if (_editandoNome &&
                                (value == null || value.isEmpty)) {
                              return 'Informe o nome';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      !_editandoNome
                          ? IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Color(0xFFF6CF1F)),
                              onPressed: () {
                                setState(() {
                                  _editandoNome = true;
                                });
                              },
                            )
                          : IconButton(
                              icon:
                                  const Icon(Icons.check, color: Colors.green),
                              onPressed: () async {
                                if (_nomeController.text.isNotEmpty) {
                                  setState(() {
                                    _editandoSenha = false;
                                  });
                                  try {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    final token = prefs.getString('token');
                                    final nameAtt = _nomeController.text;
                                    print(nameAtt);
                                    await ApiService.alterName(nameAtt, token);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Nome alterada com sucesso!')),
                                    );
                                    prefs.clear();
                                    Navigator.pushReplacementNamed(
                                        context, '/login');
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Erro ao alterar nome!')),
                                    );
                                  }
                                }
                              },
                            ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Substitua o Row atual do campo de senha por este código:
                  Column(
                    children: [
                      // Campo para senha antiga
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _senhaAntigaController,
                              enabled: _editandoSenha,
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'Senha Atual',
                                labelStyle: TextStyle(color: Color(0xFFF6CF1F)),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFF6CF1F)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFFF6CF1F), width: 2),
                                ),
                              ),
                              cursorColor: Color(0xFFF6CF1F),
                              validator: _validateSenhaAntiga,
                            ),
                          ),
                          const SizedBox(width: 8),
                          !_editandoSenha
                              ? IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Color(0xFFF6CF1F)),
                                  onPressed: () {
                                    setState(() {
                                      _editandoSenha = true;
                                    });
                                  },
                                )
                              : const SizedBox(
                                  width: 48), // Espaço para alinhar
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Campo para nova senha
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _novaSenhaController,
                              enabled: _editandoSenha,
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'Nova Senha',
                                labelStyle: TextStyle(color: Color(0xFFF6CF1F)),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFF6CF1F)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFFF6CF1F), width: 2),
                                ),
                              ),
                              cursorColor: Color(0xFFF6CF1F),
                              validator: _validateNovaSenha,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _editandoSenha
                              ? IconButton(
                                  icon: const Icon(Icons.check,
                                      color: Colors.green),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _editandoSenha = false;
                                      });
                                      try {
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        final token = prefs.getString('token');
                                        final senhaAntiga =
                                            _senhaAntigaController.text;
                                        final novaSenha =
                                            _novaSenhaController.text;

                                        await ApiService.alterPassword(
                                          senhaAntiga,
                                          novaSenha,
                                          token,
                                        );

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Senha alterada com sucesso!'),
                                          ),
                                        );
                                        prefs.clear();
                                        Navigator.pushReplacementNamed(
                                            context, '/login');
                                        // Limpa os campos
                                        _senhaAntigaController.clear();
                                        _novaSenhaController.clear();
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Erro ao alterar senha: ${e.toString()}'),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                )
                              : const SizedBox(
                                  width: 48), // Espaço para alinhar
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ),
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final token = prefs.getString('token');
                            await ApiService.deleteMe(token);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Conta Excluida com sucesso'),
                                  backgroundColor: Colors.green),
                            );
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text(
                            'Excluir Conta',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
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
