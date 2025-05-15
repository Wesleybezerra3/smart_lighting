import 'package:flutter/material.dart';
import 'widgets/header.dart';
import 'widgets/bluetoothArea.dart';
import 'widgets/menu.dart';
import 'widgets/light_control.dart';
import 'widgets/intensity_control.dart';
import 'widgets/motion_sensor_toggle.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Lighting',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Smart Lighting Home'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho
            const CustomHeader(),

            // Área de Bluetooth
            const BluetoothArea(),

            // Conteúdo principal com rolagem
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Controle de luz
                      const LightControl(),

                      const SizedBox(height: 16),

                      // Controle de intensidade
                      const IntensityControl(),

                      const SizedBox(height: 16),

                      // Alternar sensor de movimento
                      const MotionSensorToggle(),

                      const SizedBox(height: 16),

                      // Menu lateral
                      // const MenuSide(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}