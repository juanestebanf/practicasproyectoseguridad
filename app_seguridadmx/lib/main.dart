import 'package:flutter/material.dart';
import 'package:app_seguridadmx/features/auth/presentacion/screens/pantalla_bienvenida.dart';
import 'package:app_seguridadmx/features/auth/presentacion/screens/pantalla_registro.dart';
import 'package:app_seguridadmx/features/auth/presentacion/pantalla_login_user.dart'; // Verifica que esté aquí
import 'package:app_seguridadmx/rutas/rutas_app.dart';
import 'package:app_seguridadmx/features/users/presentacion/screens/home_usuario_screen.dart';
import 'package:app_seguridadmx/features/users/presentacion/screens/seleccionar_alarma_screen.dart';
import 'package:app_seguridadmx/features/users/presentacion/screens/seleccionar_contactos_screen.dart';
import 'package:app_seguridadmx/features/users/presentacion/screens/mapa_screen.dart';
// perfil
import 'package:app_seguridadmx/features/users/presentacion/screens/perfil_usuario_screen.dart';
import 'package:app_seguridadmx/features/users/presentacion/screens/datos_personales_screen.dart';
import 'package:app_seguridadmx/features/users/presentacion/screens/seguridad_cuenta_screen.dart';
import 'package:app_seguridadmx/features/users/presentacion/screens/gestionar_contactos_screen.dart';
import 'package:app_seguridadmx/features/users/presentacion/screens/historial_alarmas_screen.dart';
import 'package:app_seguridadmx/features/users/presentacion/screens/preferencias_notificacion_screen.dart';

import 'package:app_seguridadmx/features/users/presentacion/screens/alerta_cercana_screen.dart';
import 'package:app_seguridadmx/core/models/alerta_model.dart';
import 'package:app_seguridadmx/features/users/presentacion/screens/notificaciones_screen.dart';

import 'package:app_seguridadmx/features/admin/presentacion/screens/home_admin_screen.dart';


void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRutas.bienvenida,
      routes: {
        AppRutas.bienvenida: (_) => const PantallaBienvenida(),
        AppRutas.registroUsuario: (_) => const RegistroUsuarioScreen(),
        AppRutas.loginUsuario: (_) => LoginUsuarioScreen(),
        AppRutas.homeUsuario: (_) => const HomeUsuarioScreen(),
        AppRutas.seleccionarAlarma: (_) => const SeleccionarAlarmaScreen(),
        AppRutas.seleccionarContactos: (_) => SeleccionarContactosScreen(),
        AppRutas.mapa: (_) => MapaScreen(),
        AppRutas.perfil: (_) => const PerfilUsuarioScreen(),
        AppRutas.datosPersonales: (_) => const DatosPersonalesScreen(),
        AppRutas.seguridadCuenta: (_) => const SeguridadCuentaScreen(),
        AppRutas.gestionarContactos: (_) => GestionarContactosScreen(),
        AppRutas.historialAlarmas: (_) => HistorialAlarmasScreen(),
        AppRutas.preferenciasNotificacion: (_) => const PreferenciasNotificacionScreen(),
        AppRutas.notificaciones: (_) => NotificacionesScreen(),
        AppRutas.homeAdmin: (_) => const HomeAdminScreen(),
        AppRutas.alertaCercana: (context) {
          final alerta = ModalRoute.of(context)!.settings.arguments as AlertaModel;
          return AlertaCercanaScreen(alerta: alerta); 
        },
        
      },
    );
  }
}