import 'package:flutter/material.dart';
import 'package:smart_lighting/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/header.dart';
import '../widgets/bluetoothArea.dart';
import '../widgets/light_control.dart';
import '../widgets/intensity_control.dart';
import '../widgets/motion_sensor_toggle.dart';
import '../widgets/side_menu.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  bool _showMenu = false;

  void initState(){
    super.initState();
    getUserData();
  }

  void getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      await ApiService.getMe(token);
    } else {
      // Se não houver token, redireciona para a página de login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _toggleMenu() {
    setState(() {
      _showMenu = !_showMenu;
    });
  }

  void _closeMenu() {
    setState(() {
      _showMenu = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                CustomHeader(onMenuPressed: _toggleMenu),
                const BluetoothArea(),
                const SizedBox(height: 40),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const LightControl(),
                          const SizedBox(height: 40),
                          const IntensityControl(),
                          const SizedBox(height: 16),
                          const MotionSensorToggle(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_showMenu) SideMenu(onClose: _closeMenu),
          ],
        ),
      ),
    );
  }
}
