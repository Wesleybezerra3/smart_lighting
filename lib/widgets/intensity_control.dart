import 'package:flutter/material.dart';
import 'package:smart_lighting/widgets/bluetoothArea.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class IntensityControl extends StatefulWidget {
  final GlobalKey<BluetoothAreaState> bluetoothKey;
  const IntensityControl({super.key, required this.bluetoothKey});

  @override
  _IntensityControlState createState() => _IntensityControlState();
}

class _IntensityControlState extends State<IntensityControl> {
  double _intensity = 50;

  void _sendIntensity(double value) async {
    final intValue = value.toInt();
    // Mapeia de 0-100% para 0-255 (valores PWM)
    final pwmValue = (intValue * 2.55).toInt();

    final bluetooth = widget.bluetoothKey.currentState;
    if (bluetooth != null) {
      // Envia o valor PWM (0-255) como string
      bluetooth.sendBluetoothCommand('B$pwmValue\n');
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        await ApiService.sendLog({
          "id": 0,
          'tipo': 'I',
          'descricao': 'Intersidade da luz alterada',
        }, token);
      } catch (_) {
        // Ignora erro de envio de log
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF6CF1F),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Intensidade',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _intensity,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      activeColor: const Color(0xFFF1F1F1),
                      inactiveColor: const Color(0xFF0A0A0A),
                      onChanged: (value) {
                        setState(() {
                          _intensity = value;
                        });
                        _sendIntensity(value);
                      },
                      onChangeEnd: (value) {
                        _sendIntensity(value);
                      },
                    ),
                  ),
                  Text(
                    '${_intensity.toInt()}%',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
