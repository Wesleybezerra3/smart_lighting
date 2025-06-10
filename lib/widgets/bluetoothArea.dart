import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

class BluetoothArea extends StatefulWidget {
  const BluetoothArea({super.key});

  static BluetoothAreaState? of(BuildContext context) {
    return context.findAncestorStateOfType<BluetoothAreaState>();
  }

  @override
  State<BluetoothArea> createState() => BluetoothAreaState();
}

class BluetoothAreaState extends State<BluetoothArea> {
  BluetoothConnection? _connection;
  bool _connected = false;
  String _deviceName = '';
  String? _lastMessage;

  Future<void> _showBluetoothModal(BuildContext context) async {
    try {
      setState(() {
        _connected = false; // Opcional: redefinir estado antes
      });

      // Solicita permissões necessárias
      await [
        perm.Permission.bluetoothScan,
        perm.Permission.bluetoothConnect,
        perm.Permission.location
      ].request();

      // Ativa o Bluetooth
      await FlutterBluetoothSerial.instance.requestEnable();

      if (!context.mounted) return;

      // Mostra modal com loading inicial
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return FutureBuilder<List<BluetoothDevice>>(
            future: FlutterBluetoothSerial.instance.getBondedDevices(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Erro ao buscar dispositivos: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Nenhum dispositivo pareado encontrado.'),
                );
              } else {
                final devices = snapshot.data!;
                return ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: [
                    const Text(
                      'Dispositivos Bluetooth Pareados',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    ...devices.map(
                      (device) => ListTile(
                        leading: const Icon(Icons.bluetooth,
                            color: Color(0xFFF6CF1F)),
                        title: Text(device.name ?? 'Sem nome'),
                        subtitle: Text(device.address),
                        onTap: () async {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Conectando...')),
                          );

                          try {
                            final connection =
                                await BluetoothConnection.toAddress(
                                    device.address);
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
                              SnackBar(
                                  content: Text(
                                      'Conectado a ${device.name ?? device.address}'),
                                  backgroundColor: Colors.green),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Erro ao conectar: $e'),
                                  backgroundColor: Colors.red),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                );
              }
            },
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

  void sendBluetoothCommand(String command) async {
    if (_connection != null && _connection!.isConnected) {
      // Aqui a mensagem é só o caractere desejado, sem \n ou \r
      final List<int> bytes = utf8.encode(command); // ou command.codeUnits
      _connection!.output.add(Uint8List.fromList(bytes));
      await _connection!.output.allSent;
      debugPrint('✅ Comando enviado via Bluetooth: $command');
    } else {
      debugPrint('⚠️ Bluetooth não está conectado');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bluetooth não está conectado'),
          backgroundColor: Colors.red,
        ),
      );
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
          const SnackBar(
              content: Text('Desconectado do dispositivo'),
              backgroundColor: Colors.orange),
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
              _connected
                  ? 'Conectado: $_deviceName'
                  : 'Nenhum dispositivo conectado',
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
