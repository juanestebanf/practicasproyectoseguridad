import 'package:flutter/material.dart';
import 'package:app_seguridadmx/features/admin/presentacion/domain/models/alert_model.dart';
import 'package:app_seguridadmx/features/admin/presentacion/screens/alert_detail_screen.dart';

class AlertCardWidget extends StatelessWidget {
  final AlertModel alert; // ✅ Agregado
  final String type;
  final String time;
  final String location;
  final IconData icon;
  final AlertStatus status;
  final VoidCallback? onAssign;

  const AlertCardWidget({
    super.key,
    required this.alert, // ✅ Agregado
    required this.type,
    required this.time,
    required this.location,
    required this.icon,
    required this.status,
    this.onAssign,
  });

  @override
  Widget build(BuildContext context) {
    const accentRed = Color(0xFFE53935);

    // ✅ Cambiado a GestureDetector y línea de navegación activa
    return GestureDetector(
      onTap: () {
        print("Navegando a detalle de alerta: ${alert.id}");
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (_) => AlertDetailScreen(alert: alert)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1414),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: accentRed),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      _buildStatusBadge(status),
                    ],
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    color: accentRed,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey, size: 14),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          location,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                // ✅ Tu botón original: SOLO si está pendiente
                if (status == AlertStatus.pendiente)
                  ElevatedButton(
                    onPressed: onAssign,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Asignar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ... (Tu método _buildStatusBadge se mantiene igual)
  Widget _buildStatusBadge(AlertStatus status) {
    Color color;
    String text;
    switch (status) {
      case AlertStatus.pendiente: color = Colors.orange; text = "Pendiente"; break;
      case AlertStatus.en_progreso: color = Colors.blue; text = "En progreso"; break;
      case AlertStatus.despachada: color = Colors.purple; text = "Despachada"; break;
      case AlertStatus.finalizada: color = Colors.green; text = "Finalizada"; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}