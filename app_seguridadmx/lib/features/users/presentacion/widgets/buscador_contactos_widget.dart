import 'package:flutter/material.dart';

class BuscadorContactosWidget extends StatelessWidget {
  const BuscadorContactosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const Color cardDark = Color(0xFF1E1E1E);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Buscar por nombre o número...',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon:
              const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: cardDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}