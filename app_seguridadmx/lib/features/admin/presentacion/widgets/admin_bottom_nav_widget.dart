import 'package:flutter/material.dart';

class AdminBottomNavWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Color accent; 

  const AdminBottomNavWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.accent = const Color(0xFFE53935), 
  });

  @override
  Widget build(BuildContext context) {
    const backgroundDark = Color(0xFF0D0D0D);

    return BottomNavigationBar(
      backgroundColor: backgroundDark,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: accent, 
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard), 
          label: "INICIO",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          activeIcon: Icon(Icons.people),
          label: "OPERADORES",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: "HISTORIAL",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "PERFIL",
        ),
      ],
    );
  }
}