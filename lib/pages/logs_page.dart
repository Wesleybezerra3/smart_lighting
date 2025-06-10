import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_lighting/services/api_service.dart';
import 'package:intl/intl.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  var logs = [];

  @override
  void initState() {
    super.initState();
    getLogs();
  }

  void getLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await ApiService.getLog(token);
      setState(() {
        logs = response;
      });
      print(response);
    } catch (e) {
      print('Erro ao buscar logs: $e');
    }
  }

  String formatarDataHora(String dataIso, String hora) {
    try {
      final data = DateTime.parse(dataIso);
      final partesHora = hora.split(':');

      final dataHora = DateTime(
        data.year,
        data.month,
        data.day,
        int.parse(partesHora[0]),
        int.parse(partesHora[1]),
        int.parse(partesHora[2]),
      );

      final dataFormatada = DateFormat('dd/MM/yyyy').format(dataHora);
      final horaFormatada = DateFormat('HH:mm').format(dataHora);
      return '$dataFormatada às $horaFormatada';
    } catch (e) {
      return '$dataIso $hora';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Exemplo de lista de logs

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
                    'Ação: ${log['ds_reg']}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Data: ${formatarDataHora(log['dt_acao'], log['hr_acao'])}',
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
