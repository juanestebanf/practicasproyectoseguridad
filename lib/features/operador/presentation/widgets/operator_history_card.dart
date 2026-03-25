import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/app/widgets/premium_widgets.dart';
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
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        borderRadius: 22,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔝 CABECERA: PRIORIDAD Y ESTADO REAL
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OperatorPriorityBadge(prioridad: alert.prioridad),
                _buildStatusBadge(alert.finalizada),
              ],
            ),

            const SizedBox(height: 16),

            /// 🏷️ TÍTULO PREMIUM
            Text(
              alert.titulo.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 12),

            /// 📍 UBICACIÓN CON ICONO ESTILIZADO
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ColoresApp.rojoPrincipal.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on, size: 14, color: ColoresApp.rojoPrincipal),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    alert.ubicacion,
                    style: const TextStyle(color: ColoresApp.textoSecundario, fontSize: 13),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// ⏰ TIEMPO Y FECHA
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.white24),
                const SizedBox(width: 8),
                Text(
                  _formatFecha(alert.fecha),
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔘 BOTÓN TIPO VIDRIO
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.05),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  side: const BorderSide(color: Colors.white10),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("Detalles del Registro", style: TextStyle(fontSize: 14, letterSpacing: 0.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool finalizada) {
    final color = finalizada ? Colors.green : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        finalizada ? "FINALIZADA" : "EN ATENCIÓN",
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  String _formatFecha(DateTime fecha) {
    return "${fecha.day}/${fecha.month}/${fecha.year} • ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}";
  }
}