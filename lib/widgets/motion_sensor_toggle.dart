import 'package:flutter/material.dart';
import 'package:smart_lighting/widgets/bluetoothArea.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MotionSensorToggle extends StatefulWidget {
  final GlobalKey<BluetoothAreaState> bluetoothKey;
  const MotionSensorToggle({super.key, required this.bluetoothKey});

  @override
  _MotionSensorToggleState createState() => _MotionSensorToggleState();
}

class _MotionSensorToggleState extends State<MotionSensorToggle> {
  bool _isSensorOn = false;

  void _toggleSensor(bool value) async {
    setState(() {
      _isSensorOn = value;
    });
    final bluetooth = widget.bluetoothKey.currentState;
    if (bluetooth != null) {
      bluetooth.sendBluetoothCommand('S');
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        final id = prefs.getString('id');
        await ApiService.sendLog({
          "id": 0,
          'tipo': 'I',
          'descricao': _isSensorOn ? 'Sensor Ativado' : 'Sensor Desativado',
        }, token);
      } catch (_) {
        // Ignora erro de envio de log
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16.0), // Espaçamento lateral
      child: Container(
        padding: const EdgeInsets.all(16.0), // Espaçamento interno
        decoration: BoxDecoration(
          color: const Color(0xFFF6CF1F), // Cor de fundo mais opaca
          borderRadius: BorderRadius.circular(8.0), // Bordas arredondadas
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Espaça os elementos
          children: [
            // Texto
            const Text(
              'Sensor de movimento',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            // Switch
            Switch(
              value: _isSensorOn,
              activeColor: const Color(0xFF000000),
              inactiveThumbColor: const Color(0xFF0A0A0A),
              onChanged: _toggleSensor,
            ),
          ],
        ),
      ),
    );
  }
}
