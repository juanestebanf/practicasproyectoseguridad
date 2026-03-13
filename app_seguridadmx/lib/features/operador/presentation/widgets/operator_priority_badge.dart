import 'package:flutter/material.dart';

class OperatorPriorityBadge extends StatelessWidget {

  final String prioridad;

  const OperatorPriorityBadge({
    super.key,
    required this.prioridad,
  });

  @override
  Widget build(BuildContext context) {

    Color color;

    switch (prioridad.toUpperCase()) {

      case "CRITICA":
      case "CRÍTICA":
        color = const Color(0xFFE53935);
        break;

      case "ALTA":
        color = Colors.orange;
        break;

      case "MEDIA":
        color = Colors.amber;
        break;

      case "BAJA":
        color = Colors.green;
        break;

      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),

      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.4),
        ),
      ),

      child: Text(
        prioridad.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}