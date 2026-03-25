import 'package:flutter/material.dart';
import 'package:app_seguridadmx/rutas/rutas_app.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/app/widgets/premium_widgets.dart';

class HeaderHomeWidget extends StatelessWidget {
  const HeaderHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          /// 🛡️ LOGO CON GLOW
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: ColoresApp.rojoPrincipal,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: ColoresApp.rojoPrincipal.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                )
              ],
            ),
            child: const Icon(Icons.security_rounded, color: Colors.white, size: 30),
          ),
          
          const SizedBox(width: 15),
          
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SEGURIDAD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                ),
              ),
              Text(
                'Sistema de Emergencias',
                style: TextStyle(color: ColoresApp.textoSecundario, fontSize: 13),
              ),
            ],
          ),
          
          const Spacer(),

          /// 🔔 NOTIFICACIONES PREMIUM
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRutas.notificaciones),
            child: GlassContainer(
              padding: const EdgeInsets.all(10),
              borderRadius: 50,
              blur: 5,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 26),
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: ColoresApp.rojoPrincipal,
                        shape: BoxShape.circle,
                        border: Border.all(color: ColoresApp.fondoOscuro, width: 2),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}