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

  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      print(token);
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

  final GlobalKey<BluetoothAreaState> bluetoothAreaKey = GlobalKey<
      BluetoothAreaState>(); //erro aqui(The name 'BluetoothAreaState' isn't a type, so it can't be used as a type argument.
//'dynamic' doesn't conform to the bound 'State<StatefulWidget>' of the type parameter 'T'.)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                CustomHeader(onMenuPressed: _toggleMenu),
                BluetoothArea(key: bluetoothAreaKey),
                const SizedBox(height: 40),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          LightControl(bluetoothKey: bluetoothAreaKey),
                          const SizedBox(height: 40),
                          IntensityControl(bluetoothKey: bluetoothAreaKey),
                          const SizedBox(height: 16),
                          MotionSensorToggle(bluetoothKey: bluetoothAreaKey),
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
