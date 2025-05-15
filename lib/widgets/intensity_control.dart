import 'package:flutter/material.dart';

class IntensityControl extends StatefulWidget {
  const IntensityControl({super.key});

  @override
  _IntensityControlState createState() => _IntensityControlState();
}

class _IntensityControlState extends State<IntensityControl> {
  double _intensity = 80;

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
            // const Text(
            //   'Controle de Intensidade',
            //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            // ),
            // Slider e Porcentagem
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _intensity,
                      min: 0,
                      max: 100,
                      activeColor: const Color(0xFFF1F1F1),
                      inactiveColor: const Color(0xFF0A0A0A),
                      onChanged: (value) {
                        setState(() {
                          _intensity = value;
                        });
                      },
                    ),
                  ),
                  Text(
                    '${_intensity.toInt()}%',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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