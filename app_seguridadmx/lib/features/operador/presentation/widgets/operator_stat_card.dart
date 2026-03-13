import 'package:flutter/material.dart';

class OperatorStatCard extends StatelessWidget {

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const OperatorStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    const cardBg = Color(0xFF161616);

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),

        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white10),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ICONO

            Container(
              padding: const EdgeInsets.all(8),

              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),

              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),

            const SizedBox(height: 12),

            /// VALOR

            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            /// TITULO

            Text(
              title,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}