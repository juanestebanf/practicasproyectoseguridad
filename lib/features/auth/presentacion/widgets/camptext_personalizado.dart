import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';

class CampoTextoPersonalizado extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icono;
  final TextEditingController controller;
  final bool esPassword;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const CampoTextoPersonalizado({
    super.key,
    required this.label,
    required this.hint,
    required this.icono,
    required this.controller,
    this.esPassword = false,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: esPassword,
          keyboardType: keyboardType,
          style: TextStyle(color: ColoresApp.textoBlanco),
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: ColoresApp.fondoInput,
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white38),
            prefixIcon: Icon(icono, color: Colors.white38),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}