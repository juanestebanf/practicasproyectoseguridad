import 'package:flutter/material.dart';
import 'package:app_seguridadmx/rutas/rutas_app.dart';

// AUTH
import 'package:app_seguridadmx/features/auth/presentacion/screens/pantalla_bienvenida.dart';
import 'package:app_seguridadmx/features/auth/presentacion/screens/pantalla_registro.dart';
import 'package:app_seguridadmx/features/auth/presentacion/pantalla_login_user.dart';

// USER
import 'package:app_seguridadmx/features/users/presentacion/screens/home_usuario_screen.dart';
import 'package:app_seguridadmx/features/users/presentacion/screens/seleccionar_alarma_screen.dart';
import 'package:app_seguridadmx/features/users/presentacion/screens/seleccionar_contactos_screen.dart';
import 'package:app_seguridadmx/features/users/presentacion/screens/mapa_screen.dart';
import 'package:app_seguridadmx/features/users/presentacion/screens/perfil_usuario_screen.dart';
import 'package:app_seguridadmx/features/users/presentacion/screens/datos_personales_screen.dart';
import 'package:app_seguridadmx/features/users/presentacion/screens/seguridad_cuenta_screen.dart';
import 'package:app_seguridadmx/features/users/presentacion/screens/gestionar_contactos_screen.dart';
import 'package:app_seguridadmx/features/users/presentacion/screens/historial_alarmas_screen.dart';
import 'package:app_seguridadmx/features/users/presentacion/screens/preferencias_notificacion_screen.dart';
import 'package:app_seguridadmx/features/users/presentacion/screens/notificaciones_screen.dart';
import 'package:app_seguridadmx/features/users/presentacion/screens/alerta_cercana_screen.dart';

import 'package:app_seguridadmx/core/models/alerta_model.dart';

// ADMIN
import 'package:app_seguridadmx/features/admin/presentacion/screens/home_admin_screen.dart';

// OPERADOR
import 'package:app_seguridadmx/features/operador/presentation/screens/operator_dashboard_screen.dart';
import 'package:app_seguridadmx/features/operador/presentation/screens/operator_alert_detail_screen.dart';
import 'package:app_seguridadmx/features/operador/presentation/screens/operator_history_screen.dart';
import 'package:app_seguridadmx/features/operador/presentation/screens/operator_profile_screen.dart';

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

      onGenerateRoute: (settings) {

        switch (settings.name) {

          /// AUTH

          case AppRutas.bienvenida:
            return MaterialPageRoute(
              builder: (_) => const PantallaBienvenida(),
            );

          case AppRutas.registroUsuario:
            return MaterialPageRoute(
              builder: (_) => const RegistroUsuarioScreen(),
            );

          case AppRutas.loginUsuario:
            return MaterialPageRoute(
              builder: (_) => LoginUsuarioScreen(),
            );

          /// USER

          case AppRutas.homeUsuario:
            return MaterialPageRoute(
              builder: (_) => const HomeUsuarioScreen(),
            );

          case AppRutas.seleccionarAlarma:
            return MaterialPageRoute(
              builder: (_) => const SeleccionarAlarmaScreen(),
            );

          case AppRutas.seleccionarContactos:
            return MaterialPageRoute(
              builder: (_) => SeleccionarContactosScreen(),
            );

          case AppRutas.mapa:
            return MaterialPageRoute(
              builder: (_) => MapaScreen(),
            );

          case AppRutas.perfil:
            return MaterialPageRoute(
              builder: (_) => const PerfilUsuarioScreen(),
            );

          case AppRutas.datosPersonales:
            return MaterialPageRoute(
              builder: (_) => const DatosPersonalesScreen(),
            );

          case AppRutas.seguridadCuenta:
            return MaterialPageRoute(
              builder: (_) => const SeguridadCuentaScreen(),
            );

          case AppRutas.gestionarContactos:
            return MaterialPageRoute(
              builder: (_) => GestionarContactosScreen(),
            );

          case AppRutas.historialAlarmas:
            return MaterialPageRoute(
              builder: (_) => HistorialAlarmasScreen(),
            );

          case AppRutas.preferenciasNotificacion:
            return MaterialPageRoute(
              builder: (_) => const PreferenciasNotificacionScreen(),
            );

          case AppRutas.notificaciones:
            return MaterialPageRoute(
              builder: (_) => NotificacionesScreen(),
            );

          /// ALERTA CERCANA

          case AppRutas.alertaCercana:

            final alerta = settings.arguments as AlertaModel;

            return MaterialPageRoute(
              builder: (_) => AlertaCercanaScreen(alerta: alerta),
            );

          /// ADMIN

          case AppRutas.homeAdmin:
            return MaterialPageRoute(
              builder: (_) => const HomeAdminScreen(),
            );

          /// OPERADOR

          case AppRutas.homeVigilante:
            return MaterialPageRoute(
              builder: (_) => const OperatorDashboardScreen(),
            );

          case AppRutas.operatorAlertDetail:

            final alertId = settings.arguments as String;

            return MaterialPageRoute(
              builder: (_) => OperatorAlertDetailScreen(
                alertId: alertId,
              ),
            );

          case AppRutas.operatorHistory:
            return MaterialPageRoute(
              builder: (_) => const OperatorHistoryScreen(),
            );

          case AppRutas.operatorProfile:
            return MaterialPageRoute(
              builder: (_) => const OperatorProfileScreen(),
            );

          /// DEFAULT

          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(
                  child: Text("Ruta no encontrada"),
                ),
              ),
            );
        }
      },
    );
  }
}