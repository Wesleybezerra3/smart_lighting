import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_lighting/services/api_service.dart';

class SideMenu extends StatelessWidget {
  final VoidCallback onClose;
  const SideMenu({super.key, required this.onClose});

  Future<void> sendRegister() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final nome = prefs.getString('nome');
    print('Token: $token');
    print('Nome: $nome');

    if (token != null && nome != null && nome.isNotEmpty) {
      await ApiService.sendRegisters(
          {"tipo": 'L', "descricao": 'Novo Logout realizado por $nome'}, token);
    } else {
      print('Nome ou token não encontrados ao tentar enviar registro.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: onClose,
        behavior: HitTestBehavior.translucent,
        child: Row(
          children: [
            // Menu ocupa metade da tela
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Material(
                color: Color(0xFF242424),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(height: 40),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    //   child: Image.asset(
                    //     'lib/assets/logo.png',
                    //     width: 60,
                    //     height: 60,
                    //     fit: BoxFit.contain,
                    //     errorBuilder: (context, error, stackTrace) =>
                    //         const Icon(Icons.error, color: Colors.yellow),
                    //   ),
                    // ),
                    const SizedBox(height: 24),
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.white),
                      title: const Text(
                        'Meu Perfil',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/perfil');
                        onClose();
                      },
                    ),
                    const SizedBox(height: 24),
                    ListTile(
                      leading: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Logs',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/logs');
                        onClose();
                      },
                    ),
                    const SizedBox(height: 24),
                    ListTile(
                      leading: const Icon(
                        Icons.assignment,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Registros',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/registers');
                        onClose();
                      },
                    ),
                    const Spacer(),
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Color(0xFFF6CF1F),
                      ),
                      title: const Text(
                        'Sair',
                        style: TextStyle(color: Color(0xFFF6CF1F)),
                      ),
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.clear();
                        await sendRegister();
                        Navigator.pushNamed(context, '/login');
                        onClose();
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            // Área clicável para fechar o menu
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
