import 'package:flutter/material.dart';

class AdminConfigTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String sub;
  final bool? switchValue;
  final String? trailingText;

  const AdminConfigTile({
    super.key,
    required this.icon,
    required this.title,
    required this.sub,
    required this.switchValue,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding:
          const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon,
              color: const Color(0xFFE53935).withOpacity(0.7),
              size: 20),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 14)),
                Text(sub,
                    style: const TextStyle(
                        color: Colors.white24, fontSize: 11)),
              ],
            ),
          ),
          if (switchValue != null)
            Switch(
              value: switchValue!,
              onChanged: (v) {},
              activeColor: Colors.white,
              activeTrackColor:
                  const Color(0xFFE53935),
            ),
          if (trailingText != null)
            Text(trailingText!,
                style: const TextStyle(
                    color: Color(0xFFE53935),
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}