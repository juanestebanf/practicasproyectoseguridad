import 'package:flutter/material.dart';
import 'package:app_seguridadmx/features/auth/presentacion/widgets/item_caracteristica.dart';
import 'package:app_seguridadmx/rutas/rutas_app.dart';

class PantallaBienvenida extends StatelessWidget {
  const PantallaBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con degradado
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1B263B),
                  Color(0xFF0D1B2A),
                  Color(0xFF000000),
                ],
              ),
            ),
          ),
          Positioned(
            top: -50,
            right: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.red.withOpacity(0.05),
            ),
          ),
          
          // 🛠 SOLUCIÓN: Agregamos SingleChildScrollView y limitamos el tamaño con un ConstrainedBox
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          children: const [
                            SizedBox(height: 20),
                            _Encabezado(),
                            // Cambiamos Spacer por SizedBox para tener control en el scroll
                            SizedBox(height: 40), 
                            _SeccionCaracteristicas(),
                            Spacer(), // Este spacer ahora funcionará correctamente expandiendo el espacio sobrante
                            _BotonesAccion(),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}

// --- El resto de los widgets se mantienen igual, pero sin el Padding interno de 24 para no duplicar ---

class _Encabezado extends StatelessWidget {
  const _Encabezado();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.red.withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 2,
              )
            ],
          ),
          child: const Icon(Icons.shield, color: Colors.red, size: 48),
        ),
        const SizedBox(height: 24),
        const Text(
          'LOJA ALERTA',
          style: TextStyle(
            fontSize: 32,
            letterSpacing: 2,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'SEGURIDAD MUNICIPAL',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.redAccent,
            ),
          ),
        ),
      ],
    );
  }
}

class _SeccionCaracteristicas extends StatelessWidget {
  const _SeccionCaracteristicas();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: const [
          ItemCaracteristica(
            icono: Icons.security,
            titulo: 'Seguridad Ciudadana',
            subtitulo: 'Protección integral 24/7',
            color: Colors.red,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.white10),
          ),
          ItemCaracteristica(
            icono: Icons.flash_on,
            titulo: 'Solicitud Rápida',
            subtitulo: 'Conexión directa con autoridades',
            color: Colors.orange,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.white10),
          ),
          ItemCaracteristica(
            icono: Icons.people,
            titulo: 'Comunidad Protegida',
            subtitulo: 'Red de apoyo municipal solidaria',
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}

class _BotonesAccion extends StatelessWidget {
  const _BotonesAccion();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFFE53935), Color(0xFFB71C1C)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRutas.registroUsuario),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text(
              'CREAR CUENTA',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 58,
          child: OutlinedButton(
            onPressed: () => Navigator.pushNamed(context, AppRutas.loginUsuario),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white.withOpacity(0.2), width: 1.5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text(
              'INICIAR SESIÓN',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}