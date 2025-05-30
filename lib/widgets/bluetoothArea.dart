import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../services/api_service.dart';

// Exemplo: Ativar Bluetooth e listar dispositivos pareados
void listarDispositivos() async {
  // Ativa o Bluetooth (se necessário)
  await FlutterBluetoothSerial.instance.requestEnable();

  // Lista dispositivos pareados
  List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance.getBondedDevices();
  for (var device in devices) {
    print('Dispositivo: ${device.name} - ${device.address}');
  }
}

class BluetoothArea extends StatefulWidget {
  const BluetoothArea({super.key});

  static _BluetoothAreaState? of(BuildContext context) {
    return context.findAncestorStateOfType<_BluetoothAreaState>();
  }

  @override
  State<BluetoothArea> createState() => _BluetoothAreaState();
}

class _BluetoothAreaState extends State<BluetoothArea> {
  BluetoothConnection? _connection;
  bool _connected = false;
  String _deviceName = '';
  String? _lastMessage;

  Future<void> _showBluetoothModal(BuildContext context) async {
    await FlutterBluetoothSerial.instance.requestEnable();
    List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance.getBondedDevices();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Dispositivos Bluetooth Pareados', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              if (devices.isEmpty)
                const Text('Nenhum dispositivo encontrado.')
              else
                ...devices.map((device) => ListTile(
                      leading: const Icon(Icons.bluetooth, color: Color(0xFFF6CF1F)),
                      title: Text(device.name ?? 'Sem nome'),
                      subtitle: Text(device.address),
                      onTap: () async {
                        Navigator.pop(context); // Fecha o modal
                        try {
                          BluetoothConnection connection = await BluetoothConnection.toAddress(device.address);
                          setState(() {
                            _connection = connection;
                            _connected = true;
                            _deviceName = device.name ?? device.address;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Conectado a ${device.name ?? device.address}'), backgroundColor: Colors.green),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erro ao conectar: $e'), backgroundColor: Colors.red),
                          );
                        }
                      },
                    )),
            ],
          ),
        );
      },
    );
  }

  void sendBluetoothCommand(String command, [bool? value]) async {
    if (_connection != null && _connection!.isConnected) {
      // Se value for null, envia só o comando puro
      if (value == null) {
        _connection!.output.add(Uint8List.fromList(command.codeUnits));
      } else {
        // Se value não for null, envia comando + valor (exemplo: 'T1' ou 'T0')
        _connection!.output.add(Uint8List.fromList((command + (value ? '1' : '0')).codeUnits));
      }
      await _connection!.output.allSent;
    }
  }

  void _handleArduinoMessage(String message) async {
    setState(() {
      _lastMessage = message;
    });
    if (message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Arduino: $message')),
      );
      // Envia log para a API
      try {
        await ApiService.sendLog({'acao': message, 'data': DateTime.now().toIso8601String()});
      } catch (e) {
        // Opcional: mostrar erro ao enviar log
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Escuta mensagens recebidas do Arduino
    _connection?.input?.listen((Uint8List data) {
      final message = String.fromCharCodes(data).trim();
      _handleArduinoMessage(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _connected ? 'Conectado: $_deviceName' : 'Nenhum dispositivo conectado',
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          IconButton(
            icon: Image.asset(
              'lib/assets/Add.png',
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.add, color: Colors.black),
            ),
            onPressed: () {
              _showBluetoothModal(context);
            },
          ),
        ],
      ),
    );
  }
}