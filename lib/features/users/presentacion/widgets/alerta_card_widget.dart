import 'package:flutter/material.dart';
import 'package:app_seguridadmx/core/models/alerta_model.dart';

class AlertaCardWidget extends StatelessWidget {
  final AlertaModel alerta;
  final VoidCallback onTap;

  const AlertaCardWidget({
    super.key,
    required this.alerta,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const accentRed = Color(0xFFE53935);
    const cardColor = Color(0xFF1A1313);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: alerta.leida
                ? Colors.white.withOpacity(0.05)
                : accentRed.withOpacity(0.4),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded,
                color: alerta.leida ? Colors.grey : accentRed, size: 30),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alerta.tipoAlerta,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    alerta.sector,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${alerta.distancia.toStringAsFixed(0)} metros • ${_formatearFecha(alerta.fecha)}",
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),
            if (!alerta.leida)
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: accentRed,
                  shape: BoxShape.circle,
                ),
              )
          ],
        ),
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    final diff = DateTime.now().difference(fecha);
    if (diff.inMinutes < 1) return "Ahora";
    if (diff.inMinutes < 60) return "${diff.inMinutes} min";
    return "${diff.inHours} h";
  }
}