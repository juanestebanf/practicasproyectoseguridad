import 'package:flutter/material.dart';
import 'package:app_seguridadmx/core/models/alerta_model.dart';

class AlertaTimeline extends StatelessWidget {
  final AlertaModel alerta;

  const AlertaTimeline({super.key, required this.alerta});

  @override
  Widget build(BuildContext context) {
    // Lista de estados posibles
    final List<String> estados = [
      "EMITIDA",
      "RECIBIDA",
      "UNIDAD ASIGNADA",
      "ATENDIDA"
    ];

    // Buscamos en qué estado se encuentra la alerta actualmente
    int estadoIndex = estados.indexWhere(
      (e) => alerta.estado.toUpperCase().contains(e)
    );

    if (estadoIndex == -1) estadoIndex = 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 12, 25, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Barra superior decorativa del modal
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            "Seguimiento de Alerta",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          
          // Generación del Timeline
          Column(
            children: List.generate(estados.length, (i) {
              bool activo = i <= estadoIndex;
              bool esUltimo = i == estados.length - 1;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Círculo del estado
                      Icon(
                        activo ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: activo ? Colors.green : Colors.grey[700],
                        size: 26,
                      ),
                      const SizedBox(width: 15),
                      // Texto del estado
                      Text(
                        estados[i],
                        style: TextStyle(
                          color: activo ? Colors.white : Colors.grey,
                          fontWeight: activo ? FontWeight.bold : FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  // Línea vertical conectora
                  if (!esUltimo)
                    Container(
                      margin: const EdgeInsets.only(left: 12),
                      height: 30,
                      width: 2,
                      color: i < estadoIndex ? Colors.green : Colors.grey[800],
                    ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}