import 'package:flutter/material.dart';
import 'package:app_seguridadmx/core/models/alerta_model.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/app/widgets/premium_widgets.dart';
import 'package:app_seguridadmx/features/users/presentacion/widgets/alerta_timeline.dart';

class AlertaHistorialItem extends StatelessWidget {
  final AlertaModel alerta;

  const AlertaHistorialItem({
    super.key,
    required this.alerta,
  });

  String _formatRelativeTime(DateTime fecha) {
    final now = DateTime.now();
    final diff = now.difference(fecha);
    if (diff.inMinutes < 60) return "${diff.inMinutes}m";
    if (diff.inHours < 24) return "${diff.inHours}h";
    return "${fecha.day}/${fecha.month}";
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'robo': return Icons.security;
      case 'incendio': return Icons.local_fire_department;
      case 'emergencia médica': return Icons.medical_services;
      case 'accidente': return Icons.car_crash;
      default: return Icons.warning_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPublic = alerta.tipoAlerta.toUpperCase().contains('PUBLICA');
    
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: ColoresApp.fondoOscuro,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          builder: (_) => AlertaTimeline(alerta: alerta),
        );
      },
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: 20,
        child: Row(
          children: [
            /// 🔴 ICONO DINÁMICO CON GLOW
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColoresApp.rojoPrincipal.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: ColoresApp.rojoPrincipal.withOpacity(0.2)),
              ),
              child: Icon(
                _getIconForType(alerta.tipoEmergencia),
                color: ColoresApp.rojoPrincipal,
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            /// 📝 INFORMACIÓN
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isPublic ? ColoresApp.rojoPrincipal.withOpacity(0.1) : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          alerta.tipoAlerta.toUpperCase(),
                          style: TextStyle(
                            color: isPublic ? ColoresApp.rojoPrincipal : Colors.white54,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Text(
                        _formatRelativeTime(alerta.fecha),
                        style: const TextStyle(color: Colors.white24, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    alerta.tipoEmergencia,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 12, color: ColoresApp.textoSecundario),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          alerta.sector,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: ColoresApp.textoSecundario, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            /// ➡️ INDICADOR
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white10, size: 16),
          ],
        ),
      ),
    );
  }
}