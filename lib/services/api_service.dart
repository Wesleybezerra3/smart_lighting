import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000';

  static Future<dynamic> login(String rota, Map<String, dynamic> dados) async {
    final url = Uri.parse('$baseUrl/$rota');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dados),
    );
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', decodedResponse['token']);
      // Salva o tempo de expiração do token (1 hora a partir de agora)
      final expiry = DateTime.now().millisecondsSinceEpoch + 3600 * 1000;
      await prefs.setInt('token_expiry', expiry);
      return decodedResponse;
    } else {
      throw Exception('Erro ao buscar dados');
    }
  }

  static Future<dynamic> register(
    BuildContext context,
    String rota,
    Map<String, dynamic> dados,
  ) async {
    final url = Uri.parse('$baseUrl/$rota');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dados),
      );
      final decodedResponse = jsonDecode(response.body);
      if (response.statusCode != 201) {
        throw Exception('Erro ao registrar usuário');
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', decodedResponse['token']);
      // Salva o tempo de expiração do token (1 hora a partir de agora)
      final expiry = DateTime.now().millisecondsSinceEpoch + 3600 * 1000;
      await prefs.setInt('token_expiry', expiry);

      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushNamed(context, '/home');

      return decodedResponse;
    } catch (e) {
      throw Exception('Erro ao registrar usuário');
    }
  }

  static Future<void> sendLog(Map<String, dynamic> log) async {
    final url = Uri.parse('$baseUrl/logs');
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(log),
    );
  }

  static Future<void> sendRegisters(Map<String, dynamic> registers) async {
    final url = Uri.parse('$baseUrl/movements');
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(registers),
    );
  }

  static Future<void> getMe(String token) async {
    final url = Uri.parse('$baseUrl/me');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Erro ao buscar dados do usuário');
      }

      print('Dados do usuário: ${response}');
    } catch (e) {
      throw Exception('Erro ao buscar dados do usuário');
    }
  }
}
