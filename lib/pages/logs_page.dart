import 'package:flutter/material.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Exemplo de lista de logs
    final logs = [
      {'acao': 'Luz Ligada por sensor', 'data': '22/05/2025 18:30'},
      {'acao': 'Luz Desligada manualmente', 'data': '22/05/2025 19:00'},
      {'acao': 'Luz Ligada manualmente', 'data': '22/05/2025 20:10'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Logs do Sistema')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          return Card(
            color: const Color(0xFF242424), // cor de fundo do card
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ação: ${log['acao']}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Data: ${log['data']}',
                    style: const TextStyle(color: Colors.yellow, fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
