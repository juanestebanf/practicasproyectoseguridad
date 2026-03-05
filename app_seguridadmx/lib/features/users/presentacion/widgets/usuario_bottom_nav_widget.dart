import 'package:flutter/material.dart';
import 'package:app_seguridadmx/rutas/rutas_app.dart'; // Asegúrate que esta ruta sea correcta

class UsuarioBottomNavWidget extends StatelessWidget {
  final int currentIndex;

  const UsuarioBottomNavWidget({
    super.key, 
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Definimos los colores aquí o impórtalos de tu archivo de temas
    const Color backgroundDark = Color(0xFF121212);
    const Color accentRed = Color(0xFFE53935);

    return BottomNavigationBar(
      backgroundColor: backgroundDark,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: accentRed,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, AppRutas.homeUsuario);
            break;
          case 1:
            Navigator.pushReplacementNamed(context, AppRutas.mapa);
            break;
          case 2:
            Navigator.pushReplacementNamed(context, AppRutas.historialAlarmas);
            break;
          case 3:
             Navigator.pushReplacementNamed(context, AppRutas.perfil);
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'INICIO'),
        BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'MAPA'),
        BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'HISTORIAL'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'PERFIL'),
      ],
    );
  }
}