import 'package:flutter/material.dart';
import 'package:smart_lighting/widgets/bluetoothArea.dart';

class MotionSensorToggle extends StatefulWidget {
  const MotionSensorToggle({super.key});

  @override
  _MotionSensorToggleState createState() => _MotionSensorToggleState();
}

class _MotionSensorToggleState extends State<MotionSensorToggle> {
  bool _isSensorOn = false;

  void _toggleSensor(bool value) {
    setState(() {
      _isSensorOn = value;
    });
    final bluetooth = BluetoothArea.of(context);
    if (bluetooth != null) {
       bluetooth.sendBluetoothCommand('S');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Espaçamento lateral
      child: Container(
        padding: const EdgeInsets.all(16.0), // Espaçamento interno
        decoration: BoxDecoration(
          color: const Color(0xFFF6CF1F), // Cor de fundo mais opaca
          borderRadius: BorderRadius.circular(8.0), // Bordas arredondadas
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espaça os elementos
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