import 'package:flutter/material.dart';
import 'package:app_seguridadmx/rutas/rutas_app.dart';

class BotonSOSWidget extends StatelessWidget {
  const BotonSOSWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const Color accentRed = Color(0xFFE53935);

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRutas.seleccionarAlarma,
            );
          },
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentRed,
              boxShadow: [
                BoxShadow(
                  color: accentRed.withOpacity(0.4),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning_amber_rounded,
                    size: 80, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  'EMITIR\nALARMA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Mantén presionado para enviar tu ubicación en tiempo real al ECU 911',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      ],
    );
  }
}