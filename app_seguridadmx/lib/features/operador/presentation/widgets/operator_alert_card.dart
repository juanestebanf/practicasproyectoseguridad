import 'package:flutter/material.dart';
import 'package:app_seguridadmx/features/operador/models/operator_alert_model.dart';

import 'operator_priority_badge.dart';

class OperatorAlertCard extends StatelessWidget {
  final OperatorAlertModel alert;

  final VoidCallback? onAccept;
  final VoidCallback? onDetails;

  const OperatorAlertCard({
    super.key,
    required this.alert,
    this.onAccept,
    this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    const cardBg = Color(0xFF161616);
    const primaryText = Color(0xFFF5F5F5);
    const secondaryText = Color(0xFFB0B0B0);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// PRIORIDAD

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              OperatorPriorityBadge(
                prioridad: alert.prioridad,
              ),

              _statusBadge(alert.estado),
            ],
          ),

          const SizedBox(height: 12),

          /// TITULO

          Text(
            "Alerta #${alert.id}",
            style: const TextStyle(
              color: primaryText,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          /// UBICACION

          Row(
            children: [

              const Icon(
                Icons.location_on,
                size: 16,
                color: Colors.redAccent,
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  alert.ubicacion,
                  style: const TextStyle(
                    color: secondaryText,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// HORA

          Row(
            children: [

              const Icon(
                Icons.access_time,
                size: 16,
                color: Colors.white38,
              ),

              const SizedBox(width: 6),

              Text(
                "Iniciado: ${alert.fecha.hour}:${alert.fecha.minute}",
                style: const TextStyle(
                  color: secondaryText,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// BOTONES

          Row(
            children: [

              /// ACEPTAR ALERTA

              if (alert.estado == "PENDIENTE")
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53935),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Aceptar Alerta",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              if (alert.estado == "PENDIENTE")
                const SizedBox(width: 10),

              /// VER DETALLES

              Expanded(
                child: OutlinedButton(
                  onPressed: onDetails,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "Ver Detalles",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// BADGE DE ESTADO

  Widget _statusBadge(String estado) {

    Color color;

    switch (estado) {

      case "PENDIENTE":
        color = Colors.orange;
        break;

      case "EN_PROCESO":
        color = Colors.blue;
        break;

      case "FINALIZADA":
        color = Colors.green;
        break;

      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),

      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),

      child: Text(
        estado,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}