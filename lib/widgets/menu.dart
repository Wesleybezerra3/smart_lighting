import 'package:flutter/material.dart';

class MenuSide extends StatelessWidget {
  const MenuSide({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF242424),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'Menu lateral',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}