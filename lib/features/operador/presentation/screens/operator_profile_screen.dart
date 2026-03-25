import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/rutas/rutas_app.dart';
import 'package:flutter/material.dart';

import 'package:app_seguridadmx/features/operador/models/operator_model.dart';
import 'package:app_seguridadmx/features/operador/services/operator_alert_service.dart';
import 'package:app_seguridadmx/core/services/auth_service.dart';

import 'package:app_seguridadmx/features/operador/presentation/widgets/operator_bottom_nav_widget.dart';
import 'package:app_seguridadmx/features/operador/presentation/widgets/operator_stat_card.dart';
import 'package:app_seguridadmx/features/operador/presentation/widgets/operator_section_title.dart';

class OperatorProfileScreen extends StatefulWidget {
  const OperatorProfileScreen({super.key});

  @override
  State<OperatorProfileScreen> createState() => _OperatorProfileScreenState();
}

class _OperatorProfileScreenState extends State<OperatorProfileScreen> {

  final OperatorAlertService _service = OperatorAlertService();

  OperatorModel? _operator;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  /// CARGAR PERFIL

  Future<void> _loadProfile() async {

    final operator = await _service.fetchOperatorProfile();

    setState(() {
      _operator = operator;
      _loading = false;
    });
  }

  /// CERRAR SESIÓN

  void _logout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRutas.loginUsuario,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    const bgColor = ColoresApp.fondoOscuro;

    if(_loading){

      return const Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: CircularProgressIndicator(
            color: ColoresApp.rojoPrincipal,
          ),
        ),
      );
    }

    final operator = _operator!;

    return Scaffold(

      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text("Perfil operador"),
      ),

      bottomNavigationBar: const OperatorBottomNavWidget(
        currentIndex: 2,
      ),

      body: ListView(

        padding: const EdgeInsets.all(16),

        children: [

          /// PERFIL

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColoresApp.fondoInput,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: ColoresApp.rojoPrincipal.withOpacity(0.2),
                  child: const Icon(
                    Icons.person,
                    color: ColoresApp.rojoPrincipal,
                    size: 35,
                  ),
                ),

                const SizedBox(width: 16),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      operator.nombre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      operator.rol,
                      style: const TextStyle(
                        color: Colors.white60,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// ESTADISTICAS

          const OperatorSectionTitle(
            title: "Estadísticas",
          ),

          const SizedBox(height: 10),

          Row(
            children: [

              OperatorStatCard(
                title: "Alertas hoy",
                value: operator.estadisticas.alertasAtendidasHoy.toString(),
                icon: Icons.warning,
                color: Colors.orange,
              ),

              OperatorStatCard(
                title: "Eficiencia",
                value: "${operator.estadisticas.eficiencia}%",
                icon: Icons.trending_up,
                color: Colors.green,
              ),

              OperatorStatCard(
                title: "Tiempo resp.",
                value: operator.estadisticas.tiempoPromedioRespuesta,
                icon: Icons.timer,
                color: ColoresApp.info,
              ),
            ],
          ),

          const SizedBox(height: 30),

          /// BOTON CERRAR SESION

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(

              onPressed: _logout,

              style: ElevatedButton.styleFrom(
                backgroundColor: ColoresApp.rojoPrincipal,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              icon: const Icon(Icons.logout),

              label: const Text(
                "Cerrar sesión",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}