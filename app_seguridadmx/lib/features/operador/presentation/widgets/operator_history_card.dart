import 'package:flutter/material.dart';
import 'package:app_seguridadmx/features/operador/models/operator_alert_model.dart';
import 'operator_priority_badge.dart';

class OperatorHistoryCard extends StatelessWidget {

  final OperatorAlertModel alert;
  final VoidCallback? onTap;

  const OperatorHistoryCard({
    super.key,
    required this.alert,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    const cardBg = Color(0xFF161616);
    const primaryText = Color(0xFFF5F5F5);
    const secondaryText = Color(0xFFB0B0B0);

    return GestureDetector(
      onTap: onTap,

      child: Container(
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

            /// PRIORIDAD + ESTADO

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                OperatorPriorityBadge(
                  prioridad: alert.prioridad,
                ),

                _statusBadge(),
              ],
            ),

            const SizedBox(height: 10),

            /// TITULO

            Text(
              alert.titulo,
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

            /// FECHA

            Row(
              children: [

                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.white38,
                ),

                const SizedBox(width: 6),

                Text(
                  _formatFecha(alert.fecha),
                  style: const TextStyle(
                    color: secondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// BOTON VER DETALLES

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onTap,
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
      ),
    );
  }

  /// BADGE FINALIZADA

  Widget _statusBadge() {

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),

      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),

      child: const Text(
        "FINALIZADA",
        style: TextStyle(
          color: Colors.green,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// FORMATO FECHA

  String _formatFecha(DateTime fecha) {

    return "${fecha.day}/${fecha.month}/${fecha.year}  ${fecha.hour}:${fecha.minute.toString().padLeft(2,'0')}";
  }
}