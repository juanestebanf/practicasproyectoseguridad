import 'package:flutter/material.dart';

class OpcionAlarmaCard extends StatelessWidget {
  final String id;
  final String titulo;
  final String descripcion;
  final IconData icono;
  final Color colorBase;
  final bool estaSeleccionada;
  final VoidCallback onTap;

  const OpcionAlarmaCard({
    super.key,
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.colorBase,
    required this.estaSeleccionada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: estaSeleccionada
                ? colorBase
                : Colors.white10,
            width: 2,
          ),
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color:
                    colorBase.withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(10),
              ),
              child: Icon(
                icono,
                color: colorBase,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style:
                        const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descripcion,
                    style:
                        const TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}