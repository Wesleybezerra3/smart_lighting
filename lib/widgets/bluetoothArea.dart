import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

import '../services/api_service.dart';

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
    try {
      // Solicita permissões necessárias
      await perm.Permission.bluetoothScan.request();
      await perm.Permission.bluetoothConnect.request();
      await perm.Permission.location.request();

      // Ativa o Bluetooth
      await FlutterBluetoothSerial.instance.requestEnable();

      // Obtém dispositivos pareados
      List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance.getBondedDevices();

      if (!context.mounted) return;

      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Dispositivos Bluetooth Pareados',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 16),
                if (devices.isEmpty)
                  const Text('Nenhum dispositivo encontrado.')
                else
                  ...devices.map(
                    (device) => ListTile(
                      leading: const Icon(Icons.bluetooth, color: Color(0xFFF6CF1F)),
                      title: Text(device.name ?? 'Sem nome'),
                      subtitle: Text(device.address),
                      onTap: () async {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Conectando...'), duration: Duration(seconds: 2)),
                        );

                        try {
                          BluetoothConnection connection = await BluetoothConnection.toAddress(device.address);
                          setState(() {
                            _connection = connection;
                            _connected = true;
                            _deviceName = device.name ?? device.address;
                          });

                          _connection!.input!.listen((Uint8List data) {
                            final message = String.fromCharCodes(data).trim();
                            _handleArduinoMessage(message);
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
                    ),
                  ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('Erro ao exibir modal Bluetooth: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void sendBluetoothCommand(String command, [bool? value]) async {
    if (_connection != null && _connection!.isConnected) {
      String finalCommand = (value == null)
          ? '$command\n'
          : '$command${value ? '1' : '0'}\n';
      _connection!.output.add(Uint8List.fromList(finalCommand.codeUnits));
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
      try {
        await ApiService.sendLog({
          'acao': message,
          'data': DateTime.now().toIso8601String(),
        });
      } catch (_) {
        // Ignora erro de envio de log
      }
    }
  }

  void disconnect({bool showSnackbar = true}) {
    _connection?.close();
    if (mounted) {
      setState(() {
        _connection = null;
        _connected = false;
        _deviceName = '';
      });
      if (showSnackbar) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Desconectado do dispositivo'), backgroundColor: Colors.orange),
        );
      }
    }
  }

  @override
  void dispose() {
    _connection?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              _connected ? 'Conectado: $_deviceName' : 'Nenhum dispositivo conectado',
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Image.asset(
              'lib/assets/Add.png',
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.add, color: Colors.black),
            ),
            onPressed: () {
              debugPrint('Botão pressionado');
              _showBluetoothModal(context);
            },
          ),
        ],
      ),
    );
  }
}
