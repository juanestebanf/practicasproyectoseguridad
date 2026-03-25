import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/widgets/premium_widgets.dart';
import 'package:app_seguridadmx/features/admin/presentacion/domain/models/alert_model.dart';
import 'package:app_seguridadmx/features/admin/presentacion/screens/alert_detail_screen.dart';

class AlertCardWidget extends StatelessWidget {
  final AlertModel alert;
  final String type;
  final String time;
  final String location;
  final IconData icon;
  final AlertStatus status;
  final VoidCallback? onAssign;

  const AlertCardWidget({
    super.key,
    required this.alert,
    required this.type,
    required this.time,
    required this.location,
    required this.icon,
    required this.status,
    this.onAssign,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (_) => AlertDetailScreen(alert: alert)),
        );
      },
      child: GlassContainer(
        borderRadius: 22,
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                /// 🚨 ICONO CON GLOW
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColoresApp.rojoPrincipal.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: ColoresApp.rojoPrincipal, size: 22),
                ),
                const SizedBox(width: 16),
                
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
                      const SizedBox(height: 6),
                      _buildStatusBadge(status),
                    ],
                  ),
                ),
                
                Text(
                  time,
                  style: const TextStyle(
                    color: ColoresApp.rojoPrincipal,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 18),
            
            Row(
              children: [
                const Icon(Icons.location_on, color: ColoresApp.textoSecundario, size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: ColoresApp.textoSecundario, fontSize: 13),
                  ),
                ),
                
                if (status == AlertStatus.pendiente)
                  const SizedBox(width: 10),
                
                if (status == AlertStatus.pendiente)
                  ElevatedButton(
                    onPressed: onAssign,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColoresApp.rojoPrincipal,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      minimumSize: const Size(80, 36),
                    ),
                    child: const Text("Asignar", style: TextStyle(fontSize: 12)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(AlertStatus status) {
    Color color;
    String text;
    switch (status) {
      case AlertStatus.pendiente: color = Colors.orange; text = "PENDIENTE"; break;
      case AlertStatus.en_progreso: color = ColoresApp.info; text = "EN CURSO"; break;
      case AlertStatus.autoridad_asignada: color = Colors.purpleAccent; text = "ASIGNADA"; break;
      case AlertStatus.esperando_aprobacion: color = Colors.amber; text = "POR APROBAR"; break;
      case AlertStatus.finalizada: color = Colors.green; text = "FINALIZADA"; break;
      case AlertStatus.rechazada: color = Colors.red; text = "RECHAZADA"; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }
}