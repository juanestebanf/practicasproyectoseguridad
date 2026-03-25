import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import '../widgets/header_home_widget.dart';
import '../widgets/estado_sistema_widget.dart';
import '../widgets/boton_sos_widget.dart';
import '../widgets/acciones_rapidas_widget.dart';
import '../widgets/usuario_bottom_nav_widget.dart';

class HomeUsuarioScreen extends StatelessWidget {
  const HomeUsuarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundDark = ColoresApp.fondoOscuro;

    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const HeaderHomeWidget(),
              const SizedBox(height: 10),
              const EstadoSistemaWidget(),
              const SizedBox(height: 30),
              const BotonSOSWidget(),
              const SizedBox(height: 40),
              const AccionesRapidasWidget(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const UsuarioBottomNavWidget(currentIndex: 0),
    );
  }
}