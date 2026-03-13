import 'package:flutter/material.dart';

import 'package:app_seguridadmx/features/operador/models/operator_alert_model.dart';
import 'package:app_seguridadmx/features/operador/models/operator_model.dart';

import 'package:app_seguridadmx/features/operador/services/operator_alert_service.dart';

import 'package:app_seguridadmx/features/operador/presentation/widgets/operator_alert_card.dart';
import 'package:app_seguridadmx/features/operador/presentation/widgets/operator_stat_card.dart';
import 'package:app_seguridadmx/features/operador/presentation/widgets/operator_bottom_nav_widget.dart';
import 'package:app_seguridadmx/features/operador/presentation/widgets/operator_section_title.dart';

import 'package:app_seguridadmx/rutas/rutas_app.dart';

class OperatorDashboardScreen extends StatefulWidget {
  const OperatorDashboardScreen({super.key});

  @override
  State<OperatorDashboardScreen> createState() =>
      _OperatorDashboardScreenState();
}

class _OperatorDashboardScreenState extends State<OperatorDashboardScreen> {

  final OperatorAlertService _service = OperatorAlertService();

  OperatorModel? _operator;

  List<OperatorAlertModel> _alerts = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// CARGAR DATOS

  Future<void> _loadData() async {

    final operator = await _service.fetchOperatorProfile();

    final alerts = await _service.fetchAssignedAlerts();

    setState(() {
      _operator = operator;
      _alerts = alerts;
      _loading = false;
    });
  }

  /// ACEPTAR ALERTA

  Future<void> _acceptAlert(String alertId) async {

    final success = await _service.acceptAlert(alertId);

    if (success) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {

    const bgColor = Color(0xFF0D0D0D);

    if (_loading) {
      return const Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFE53935),
          ),
        ),
      );
    }

    final operator = _operator!;

    return Scaffold(

      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: const Text("Panel del operador"),
      ),

      bottomNavigationBar: const OperatorBottomNavWidget(
        currentIndex: 0,
      ),

      body: RefreshIndicator(

        onRefresh: _loadData,

        child: ListView(

          padding: const EdgeInsets.all(16),

          children: [

            /// NOMBRE OPERADOR

            Text(
              "Bienvenido, ${operator.nombre}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            /// ESTADISTICAS

            Row(
              children: [

                OperatorStatCard(
                  title: "Alertas hoy",
                  value: operator.estadisticas.alertasAtendidasHoy.toString(),
                  icon: Icons.warning_amber,
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
                  color: Colors.blue,
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// SECCION ALERTAS

            const OperatorSectionTitle(
              title: "Alertas activas",
            ),

            const SizedBox(height: 10),

            /// LISTA ALERTAS

            if (_alerts.isEmpty)

              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "No hay alertas asignadas",
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              )

            else

              ..._alerts.map(

                (alert) => OperatorAlertCard(

                  alert: alert,

                  onAccept: () {
                    _acceptAlert(alert.id);
                  },

                  onDetails: () {

                    Navigator.pushNamed(
                      context,
                      AppRutas.operatorAlertDetail,
                      arguments: alert.id,
                    ).then((_) {
                      _loadData();
                    });

                  },
                ),

              ),
          ],
        ),
      ),
    );
  }
}