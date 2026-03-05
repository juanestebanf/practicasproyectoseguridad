import 'package:flutter/material.dart';
import '../widgets/header_home_widget.dart';
import '../widgets/estado_sistema_widget.dart';
import '../widgets/boton_sos_widget.dart';
import '../widgets/acciones_rapidas_widget.dart';
import '../widgets/usuario_bottom_nav_widget.dart';

class HomeUsuarioScreen extends StatelessWidget {
  const HomeUsuarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color backgroundDark = Color(0xFF1A1A1A);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: const SafeArea(
        child: Column(
          children: [
            HeaderHomeWidget(),
            Spacer(),
            EstadoSistemaWidget(),
            SizedBox(height: 40),
            BotonSOSWidget(),
            SizedBox(height: 40),
            AccionesRapidasWidget(),
            SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: UsuarioBottomNavWidget(currentIndex: 0),
    );
  }
}