import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Image.asset(
                'lib/assets/logo.png',
                width: 30,
                height: 38,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error, color: Colors.yellow),
              ),
              const SizedBox(width: 8),
              const Text(
                'Smart Lighting',
                style: TextStyle(
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          // Menu
          IconButton(
            icon: Image.asset(
              'lib/assets/menu.png',
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.menu, color: Colors.white),
            ),
            onPressed: () {
              // Ação do menu
            },
          ),
        ],
      ),
    );
  }
}