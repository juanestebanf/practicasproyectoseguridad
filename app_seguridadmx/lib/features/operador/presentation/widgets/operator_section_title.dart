import 'package:flutter/material.dart';

class OperatorSectionTitle extends StatelessWidget {

  final String title;

  const OperatorSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),

      child: Row(
        children: [

          Container(
            width: 4,
            height: 18,

            decoration: BoxDecoration(
              color: const Color(0xFFE53935),
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          const SizedBox(width: 8),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}