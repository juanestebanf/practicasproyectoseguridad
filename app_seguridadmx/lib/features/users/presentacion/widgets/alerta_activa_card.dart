import 'package:flutter/material.dart';

class AlertaActivaCard extends StatelessWidget {
  final String tipo;
  final String alcance;
  final String tiempo;
  final bool puedeCancelar;
  final VoidCallback onCancelar;

  const AlertaActivaCard({
    required this.tipo,
    required this.alcance,
    required this.tiempo,
    required this.puedeCancelar,
    required this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1414),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10)
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius:
                  BorderRadius.circular(5),
            ),
            child: const Text(
              "ALERTA ACTIVA",
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            tipo,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Alcance: $alcance",
            style: const TextStyle(
                color: Colors.white54,
                fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            "Tiempo transcurrido: $tiempo",
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 13),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  puedeCancelar ? onCancelar : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(
                        vertical: 15),
              ),
              child: Text(
                puedeCancelar
                    ? "Cancelar (${3 - int.parse(tiempo.split(':')[1])}s)"
                    : "Alerta enviada",
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}