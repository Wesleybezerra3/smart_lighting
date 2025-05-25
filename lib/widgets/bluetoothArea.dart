import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

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


class BluetoothArea extends StatelessWidget {
  const BluetoothArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Nenhum dispositivo conectado',
            style: TextStyle(
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
              // Chama a função para listar dispositivos
              listarDispositivos();
            },
          ),
        ],
      ),
    );
  }
}