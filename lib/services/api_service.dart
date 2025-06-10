import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://uninassau.cyberscripts.com.br';

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
      print(decodedResponse);
    } else {
      print('Erro ao buscar dados');
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

      print(decodedResponse);
    } catch (e) {
      throw Exception('Erro ao registrar usuário');
    }
  }

  static Future<void> sendLog(Map<String, dynamic> log, String? token) async {
    final url = Uri.parse('$baseUrl/logs/new');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(log),
      );
      if (response.statusCode != 200) {
        print('Erro ao enviar log ${response.body}');
        throw Exception('Erro ao enviar log');
      }
      print('Log Enviado com sucesso');
    } catch (e) {
      print('Erro ao enviar registro');
      throw Exception('Erro ao enviar log ');
    }
  }

  static Future<List<dynamic>> getLog(String? token) async {
    final url = Uri.parse('$baseUrl/logs/get');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode != 200) {
        print('Erro ao buscar registros');
        throw Exception('Erro ao buscar registros');
      }
      final decodedResponse = jsonDecode(response.body);
      print(decodedResponse);
      return decodedResponse;
    } catch (e) {
      print('Erro ao buscar logs');
      throw Exception('Erro ao buscar logs');
    }
  }

  static Future<void> sendRegisters(
      Map<String, dynamic> registers, String? token) async {
    final url = Uri.parse('$baseUrl/movements/new');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(registers),
      );
      if (response.statusCode != 200) {
        print('Erro ao enviar registro');
      }
      print('Registro enviado com sucesso');
    } catch (e) {
      print('Erro ao enviar registro');
    }
  }

  static Future<List<dynamic>> getRegisters(String? token) async {
    final url = Uri.parse('$baseUrl/movements/get');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode != 200) {
        print('Erro ao buscar registros');
        throw Exception('Erro ao buscar registros');
      }
      // print(response.body);
      final decodedResponse = jsonDecode(response.body);

      // final json = {
      //   "data_registro": decodedResponse.data_registro,
      //   "hora_registro": decodedResponse.hora_registro
      // };

      // final resultado =
      //     formatarDataHora(json['data_registro']!, json['hora_registro']!);
      // print(resultado);
      return decodedResponse;
    } catch (e) {
      print('Erro ao buscar registros');
      throw Exception('Erro ao buscar registros');
    }
  }

  static Future<void> getMe(String? token) async {
    final url = Uri.parse('$baseUrl/account/me');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        print('Erro ao buscar dados do usuário');
        throw Exception('Erro ao buscar dados do usuário');
      }
      final decodedResponse = jsonDecode(response.body);
      print('Dados do usuário: ${decodedResponse}');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('id', decodedResponse['id'].toString());
      await prefs.setString('nome', decodedResponse['nome'] ?? '');
      await prefs.setString('login', decodedResponse['login'] ?? '');
    } catch (e) {
      throw Exception('Erro ao buscar dados do usuário');
    }
  }

  static Future<void> deleteMe(String? token) async {
    final url = Uri.parse('$baseUrl/account/user');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode != 200) {
        print('Erro ao deletar usuário: ${response.body}');
        throw Exception();
      }
      print('Usuário deletado com sucesso');
    } catch (e) {
      print('Erro ao deletar usuário: ${e}');
      throw Exception('Erro ao deletar usuário: ${e}');
    }
  }

  static Future<void> alterName(String? name, String? token) async {
    final url = Uri.parse('$baseUrl/account/name');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"name": name}), // Converta o Map para JSON string
      );

      if (response.statusCode != 200) {
        print('Erro ao alterar nome: ${response.body}');
        throw Exception('Failed to change name');
      }
      print('Nome alterado para $name com sucesso');
    } catch (e) {
      print('Erro ao alterar nome: $e');
      throw Exception('Failed to change name: $e');
    }
  }

  static Future<void> alterPassword(
      String? password, String? newPassword, String? token) async {
    final url = Uri.parse('$baseUrl/account/password');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "password": password,
          "newPassword": newPassword
        }), // Converta o Map para JSON string
      );

      if (response.statusCode != 200) {
        print('Erro ao alterar senha: ${response.body}');
        throw Exception('Failed to change name');
      }
      print('senha alterado com sucesso');
    } catch (e) {
      print('Erro ao alterar nome: $e');
      throw Exception('Failed to change name: $e');
    }
  }
}
