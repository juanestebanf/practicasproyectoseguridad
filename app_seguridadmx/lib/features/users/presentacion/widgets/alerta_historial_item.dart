import 'package:flutter/material.dart';
import 'package:app_seguridadmx/core/models/alerta_model.dart';
import 'package:app_seguridadmx/features/users/presentacion/widgets/alerta_timeline.dart';

class AlertaHistorialItem extends StatelessWidget {
  final AlertaModel alerta;

  const AlertaHistorialItem({
    super.key,
    required this.alerta,
  });

  bool get isPublica => alerta.tipoAlerta.toUpperCase().contains('PUBLICA');

  String formatearFecha(DateTime fecha) {
    final ahora = DateTime.now();
    final diferencia = ahora.difference(fecha);

    if (diferencia.inMinutes < 60) {
      return "${diferencia.inMinutes} min";
    } else if (diferencia.inHours < 24) {
      return "${diferencia.inHours} h";
    } else {
      return "${fecha.day}/${fecha.month}/${fecha.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: const Color(0xFF1A1A1A),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => AlertaTimeline(alerta: alerta),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            /// Icono de alerta
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.warning,
                color: Colors.redAccent,
              ),
            ),

            const SizedBox(width: 15),

            /// Información
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Badge + fecha
                  Row(
                    children: [
                      _buildBadge(alerta.tipoAlerta),
                      const SizedBox(width: 10),
                      Text(
                        formatearFecha(alerta.fecha),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// Tipo de emergencia
                  Text(
                    alerta.tipoEmergencia,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// Sector
                  Text(
                    alerta.sector,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            /// Botón mapa decorativo
            CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.05),
              child: const Icon(
                Icons.map_outlined,
                color: Colors.redAccent,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String texto) {
    final esPublica = texto.toUpperCase().contains('PUBLICA');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: esPublica
            ? Colors.red.withOpacity(0.2)
            : Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        texto.toUpperCase(),
        style: TextStyle(
          color: esPublica ? Colors.redAccent : Colors.grey,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}