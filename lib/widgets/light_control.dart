import 'package:flutter/material.dart';
import 'package:smart_lighting/widgets/bluetoothArea.dart';

class LightControl extends StatefulWidget {
  const LightControl({super.key});

  @override
  _LightControlState createState() => _LightControlState();
}

class _LightControlState extends State<LightControl> {
  bool _isLightOn = false;

  void _toggleLight() {
    setState(() {
      _isLightOn = !_isLightOn;
    });
    // Envia comando Bluetooth se conectado
    final bluetooth = BluetoothArea.of(context);
    if (bluetooth != null) {
      // Envia apenas o comando 'T' (sem JSON)
      bluetooth.sendBluetoothCommand('T');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text.rich(
          TextSpan(
            text: 'Iluminação ',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: _isLightOn ? 'Ligada' : 'Desligada',
                style: TextStyle(
                  color: _isLightOn ? Color(0xFFF6CF1F) : Color(0xFF1F1F1F),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _toggleLight,
          child: Container(
            width: 300,
            height: 300,
            child: Center(
              child: Image.asset(
                _isLightOn
                    ? 'lib/assets/btnOn.png' // Caminho da imagem para "ligado"
                    : 'lib/assets/btnOff.png', // Caminho da imagem para "desligado"
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }
}