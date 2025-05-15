import 'package:flutter/material.dart';

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
            'Lâmpada 0F13d Smart',
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
              // Ação do botão
            },
          ),
        ],
      ),
    );
  }
}