import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/widgets/premium_stat_card.dart';

class StatCardWidget extends StatelessWidget {
  final String label;
  final String value;
  final String subtext;
  final IconData icon;
  final Color color;

  const StatCardWidget({
    super.key,
    required this.label,
    required this.value,
    required this.subtext,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumStatCard(
      title: label,
      value: value,
      subtext: subtext,
      icon: icon,
      color: color,
    );
  }
}