import 'package:flutter/material.dart';
import 'package:smart_lighting/widgets/bluetoothArea.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LightControl extends StatefulWidget {
  final GlobalKey<BluetoothAreaState>
      bluetoothKey; //erro aqui(The name 'BluetoothAreaState' isn't a type, so it can't be used as a type argument.)
  const LightControl({super.key, required this.bluetoothKey});

  @override
  _LightControlState createState() => _LightControlState();
}

class _LightControlState extends State<LightControl> {
  bool _isLightOn = false;

  void _toggleLight() async {
    setState(() {
      _isLightOn = !_isLightOn;
    });

    final bluetooth = widget.bluetoothKey.currentState;
    if (bluetooth != null) {
      final command = 'T';
      bluetooth.sendBluetoothCommand(command);
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');

        await ApiService.sendLog({
          "id": 0,
          'tipo': 'I',
          'descricao': _isLightOn
              ? 'Luz Ligada manulamente'
              : 'Luz Desligada manualmente',
        }, token);
      } catch (_) {
        // Ignora erro de envio de log
      }
    } else {
      return;
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
