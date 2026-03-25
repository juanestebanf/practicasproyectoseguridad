import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/app/widgets/premium_widgets.dart';
import 'package:app_seguridadmx/rutas/rutas_app.dart';

class PantallaBienvenida extends StatelessWidget {
  const PantallaBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondoOscuro,
      body: Stack(
        children: [
          /// 🌑 FONDO DINÁMICO CON GRADIENTES PROFUNDOS
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1A1A1A),
                    ColoresApp.fondoOscuro,
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),

          /// 🔴 ORBES DE LUZ (Efecto Neon/Glow)
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColoresApp.rojoPrincipal.withOpacity(0.08),
              ),
            ),
          ),
          
          Positioned(
            bottom: -50,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.05),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  /// 🛡️ LOGO PREMIUM
                  _LogoPremium(),

                  const SizedBox(height: 40),

                  /// 💎 TEXTO DE BIENVENIDA
                  const Text(
                    'SEGURIDAD',
                    style: TextStyle(
                      fontSize: 40,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: ColoresApp.rojoPrincipal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: ColoresApp.rojoPrincipal.withOpacity(0.2)),
                    ),
                    child: const Text(
                      'PROTECCIÓN INTELIGENTE 24/7',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: ColoresApp.rojoPrincipal,
                        letterSpacing: 2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  /// 📜 CARACTERÍSTICAS (GLASS)
                  _FeatureItem(
                    icon: Icons.flash_on_rounded, 
                    title: 'Respuesta Instantánea', 
                    subtitle: 'Conexión directa con agentes en tiempo real.',
                  ),
                  const SizedBox(height: 20),
                  _FeatureItem(
                    icon: Icons.gps_fixed_rounded, 
                    title: 'Geo-Localización Precisa', 
                    subtitle: 'Rastreo y monitoreo de emergencias crítico.',
                  ),

                  const SizedBox(height: 48),

                  /// 🚀 BOTONES DE ACCIÓN (PREMIUM)
                  _BotonPrincipal(
                    text: 'CREAR NUEVA CUENTA',
                    isPrimary: true,
                    onPressed: () => Navigator.pushNamed(context, AppRutas.registroUsuario),
                  ),
                  const SizedBox(height: 16),
                  _BotonPrincipal(
                    text: 'INICIAR SESIÓN',
                    isPrimary: false,
                    onPressed: () => Navigator.pushNamed(context, AppRutas.loginUsuario),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoPremium extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColoresApp.rojoPrincipal.withOpacity(0.1),
            border: Border.all(color: ColoresApp.rojoPrincipal.withOpacity(0.3), width: 1),
          ),
        ),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.05),
            boxShadow: [
              BoxShadow(
                color: ColoresApp.rojoPrincipal.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 5,
              )
            ],
          ),
          child: const Icon(Icons.shield_rounded, color: Colors.white, size: 54),
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureItem({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: ColoresApp.rojoPrincipal, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: ColoresApp.textoSecundario, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BotonPrincipal extends StatelessWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _BotonPrincipal({required this.text, required this.isPrimary, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: isPrimary ? BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [ColoresApp.rojoBrillante, ColoresApp.rojoPrincipal],
        ),
        boxShadow: [
          BoxShadow(
            color: ColoresApp.rojoPrincipal.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ) : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.transparent : Colors.white10,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: isPrimary ? BorderSide.none : BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 1),
        ),
      ),
    );
  }
}