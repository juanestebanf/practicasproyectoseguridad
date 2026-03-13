import 'package:flutter/material.dart';
import 'package:app_seguridadmx/rutas/rutas_app.dart';

class OperatorBottomNavWidget extends StatelessWidget {

  final int currentIndex;

  const OperatorBottomNavWidget({
    super.key,
    required this.currentIndex,
  });

  void _onItemTapped(BuildContext context, int index) {

    switch (index) {

      case 0:
        Navigator.pushReplacementNamed(
          context,
          AppRutas.homeVigilante,
        );
        break;

      case 1:
        Navigator.pushReplacementNamed(
          context,
          AppRutas.operatorHistory,
        );
        break;

      case 2:
        Navigator.pushReplacementNamed(
          context,
          AppRutas.operatorProfile,
        );
        break;

    }
  }

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(

      currentIndex: currentIndex,

      onTap: (index) => _onItemTapped(context, index),

      backgroundColor: const Color(0xFF0D0D0D),

      selectedItemColor: const Color(0xFFE53935),

      unselectedItemColor: Colors.white54,

      type: BottomNavigationBarType.fixed,

      items: const [

        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: "Dashboard",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: "Historial",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Perfil",
        ),
      ],
    );
  }
}