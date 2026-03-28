import 'package:flutter/material.dart';
import 'package:app_seguridadmx/rutas/rutas_app.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';

// CORE
import 'package:app_seguridadmx/core/services/auth_service.dart';

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

import 'package:app_seguridadmx/core/services/socket_service.dart';
import 'package:app_seguridadmx/features/auth/presentacion/screens/pantalla_olvido_password.dart';
import 'package:app_seguridadmx/features/auth/presentacion/screens/pantalla_restablecer_password.dart';

import 'dart:ui';

void main() {
  // Capturar errores de Flutter (errores de widgets/framework)
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint("🚨 [FLUTTER ERROR]: ${details.exception}");
    debugPrint("🚨 [STACK TRACE]: ${details.stack}");
  };

  // Capturar errores de la plataforma (errores asíncronos fuera de Flutter)
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint("🚨 [PLATFORM ERROR]: $error");
    debugPrint("🚨 [STACK TRACE]: $stack");
    return true; // Indicar que el error ha sido manejado
  };

  WidgetsFlutterBinding.ensureInitialized();
  
  // INICIALIZAR SOCKETS
  SocketService().connect();
  
  runApp(const MiApp());
}

class MiApp extends StatefulWidget {
  const MiApp({super.key});

  @override
  State<MiApp> createState() => _MiAppState();
}

class _MiAppState extends State<MiApp> {
  String _initialRoute = AppRutas.bienvenida;
  bool _checkingSession = true;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final loggedIn = await AuthService.isLoggedIn();
    if (loggedIn) {
      final rol = await AuthService.getUserRol();
      setState(() {
        switch (rol) {
          case "admin":
            _initialRoute = AppRutas.homeAdmin;
            break;
          case "vigilante":
          case "operador":
            _initialRoute = AppRutas.homeVigilante;
            break;
          case "user":
            _initialRoute = AppRutas.homeUsuario;
            break;
          default:
            _initialRoute = AppRutas.bienvenida;
        }
        _checkingSession = false;
      });
    } else {
      setState(() {
        _checkingSession = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: ValueKey(_checkingSession), // Forzar reconstrucción limpia al cambiar de estado
      debugShowCheckedModeBanner: false,
      title: 'SEGURIDAD',
      themeMode: ThemeMode.dark,
      
      // TEMA OSCURO PREMIUM
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: ColoresApp.rojoPrincipal,
        scaffoldBackgroundColor: ColoresApp.fondoOscuro,
        
        colorScheme: ColorScheme.dark(
          primary: ColoresApp.rojoPrincipal,
          secondary: ColoresApp.rojoBrillante,
          surface: ColoresApp.fondoInput,
          // ignore: deprecated_member_use
          background: ColoresApp.fondoOscuro,
          error: ColoresApp.error,
        ),

        // Estilo de Texto Global
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: ColoresApp.textoBlanco, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: ColoresApp.textoBlanco),
          bodyMedium: TextStyle(color: ColoresApp.textoSecundario),
        ),

        // ESTILO DE BOTONES GLOBAL
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColoresApp.rojoPrincipal,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: ColoresApp.rojoPrincipal,
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: ColoresApp.textoBlanco,
            side: const BorderSide(color: Colors.white12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: ColoresApp.fondoInput,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: ColoresApp.rojoPrincipal, width: 1.5),
          ),
        ),

        dialogTheme: DialogThemeData(
          backgroundColor: ColoresApp.fondoInput,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          contentTextStyle: const TextStyle(color: ColoresApp.textoSecundario, fontSize: 16),
        ),

        snackBarTheme: SnackBarThemeData(
          backgroundColor: ColoresApp.fondoInput,
          contentTextStyle: const TextStyle(color: Colors.white),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      
      // Mostrar pantalla de carga o la ruta inicial
      home: _checkingSession 
        ? const Scaffold(
            backgroundColor: ColoresApp.fondoOscuro,
            body: Center(child: CircularProgressIndicator(color: ColoresApp.rojoPrincipal)),
          )
        : null,

      initialRoute: _checkingSession ? null : _initialRoute,

      onGenerateRoute: (settings) {
        if (_checkingSession) return null;

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
              builder: (_) => const LoginUsuarioScreen(),
            );

          case AppRutas.olvidoPassword:
            return MaterialPageRoute(
              builder: (_) => const PantallaOlvidoPassword(),
            );

          case AppRutas.restablecerPassword:
            return MaterialPageRoute(
              builder: (_) => const PantallaRestablecerPassword(),
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
              builder: (_) => const SeleccionarContactosScreen(),
            );

          case AppRutas.mapa:
            return MaterialPageRoute(
              builder: (_) => const MapaScreen(),
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
              builder: (_) => const GestionarContactosScreen(),
            );

          case AppRutas.historialAlarmas:
            return MaterialPageRoute(
              builder: (_) => const HistorialAlarmasScreen(),
            );

          case AppRutas.preferenciasNotificacion:
            return MaterialPageRoute(
              builder: (_) => const PreferenciasNotificacionScreen(),
            );

          case AppRutas.notificaciones:
            return MaterialPageRoute(
              builder: (_) => const NotificacionesScreen(),
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