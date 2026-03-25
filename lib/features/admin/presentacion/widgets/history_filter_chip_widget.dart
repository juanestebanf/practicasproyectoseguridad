import 'package:flutter/material.dart';

class HistoryFilterChipWidget extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;

  const HistoryFilterChipWidget({
    super.key,
    required this.label,
    required this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: FilterChip(
        label: Text(label),
        labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.grey),
        onSelected: (val) {},
        avatar: Icon(icon,
            size: 16,
            color: isSelected ? Colors.white : Colors.grey),
        backgroundColor: const Color(0xFF1A1A1A),
        selectedColor: const Color(0xFFE53935),
        selected: isSelected,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}