import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/app/widgets/premium_widgets.dart';
import 'package:app_seguridadmx/features/operador/models/operator_alert_model.dart';
import 'package:app_seguridadmx/features/operador/models/operator_model.dart';
import 'package:app_seguridadmx/features/operador/services/operator_alert_service.dart';
import 'package:app_seguridadmx/features/operador/presentation/widgets/operator_alert_card.dart';
import 'package:app_seguridadmx/features/operador/presentation/widgets/operator_stat_card.dart';
import 'package:app_seguridadmx/features/operador/presentation/widgets/operator_bottom_nav_widget.dart';
import 'package:app_seguridadmx/features/operador/presentation/widgets/operator_section_title.dart';
import 'package:app_seguridadmx/rutas/rutas_app.dart';
import 'package:app_seguridadmx/core/services/socket_service.dart';
import 'dart:async';

class OperatorDashboardScreen extends StatefulWidget {
  const OperatorDashboardScreen({super.key});

  @override
  State<OperatorDashboardScreen> createState() => _OperatorDashboardScreenState();
}

class _OperatorDashboardScreenState extends State<OperatorDashboardScreen> {
  final OperatorAlertService _service = OperatorAlertService();
  OperatorModel? _operator;
  List<OperatorAlertModel> _alerts = [];
  bool _loading = true;
  StreamSubscription? _socketSubscription;

  @override
  void initState() {
    super.initState();
    _loadData();
    _initSocketListener();
  }

  void _initSocketListener() {
    _socketSubscription = SocketService().alertStream.listen((data) {
      if (mounted) {
        _loadData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("🚨 ¡Nueva alerta en el sistema!"),
            backgroundColor: ColoresApp.rojoPrincipal,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 4),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _socketSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    final operator = await _service.fetchOperatorProfile();
    final alerts = await _service.fetchAssignedAlerts();
    if (mounted) {
      setState(() {
        _operator = operator;
        _alerts = alerts;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _operator == null) {
      return const Scaffold(
        backgroundColor: ColoresApp.fondoOscuro,
        body: Center(child: CircularProgressIndicator(color: ColoresApp.rojoPrincipal)),
      );
    }

    final operator = _operator!;

    return Scaffold(
      backgroundColor: ColoresApp.fondoOscuro,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: ColoresApp.rojoPrincipal,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                /// 🛡️ OPERATOR HEADER
                _OperatorHeader(operator: operator),

                const SizedBox(height: 30),

                /// 📊 ESTADÍSTICAS (GLASS)
                Row(
                  children: [
                    OperatorStatCard(
                      title: "Hoy",
                      value: operator.estadisticas.alertasAtendidasHoy.toString(),
                      icon: Icons.flash_on_rounded,
                      color: Colors.orangeAccent,
                    ),
                    OperatorStatCard(
                      title: "Eficiencia",
                      value: "${operator.estadisticas.eficiencia}%",
                      icon: Icons.trending_up_rounded,
                      color: Colors.greenAccent,
                    ),
                    OperatorStatCard(
                      title: "Respuesta",
                      value: operator.estadisticas.tiempoPromedioRespuesta,
                      icon: Icons.timer_outlined,
                      color: ColoresApp.info,
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                const PremiumSectionTitle(
                  title: "Alertas Asignadas",
                  subtitle: "Acciones rápidas para respuesta inmediata",
                  icon: Icons.notification_important_rounded,
                ),

                const SizedBox(height: 16),

                /// 📋 LISTA DE ALERTAS
                if (_alerts.isEmpty)
                  _buildEmptyState()
                else
                  ..._alerts.map((alert) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OperatorAlertCard(
                      alert: alert,
                      onAccept: () async {
                        final success = await _service.acceptAlert(alert.id);
                        if (success) _loadData();
                      },
                      onDetails: () {
                        Navigator.pushNamed(context, AppRutas.operatorAlertDetail, arguments: alert.id).then((_) => _loadData());
                      },
                    ),
                  )),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const OperatorBottomNavWidget(currentIndex: 0),
    );
  }

  Widget _buildEmptyState() {
    return GlassContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      borderRadius: 20,
      child: const Column(
        children: [
          Icon(Icons.check_circle_outline_rounded, color: Colors.greenAccent, size: 40),
          SizedBox(height: 16),
          Text(
            "Todo Bajo Control",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(
            "No tienes alertas pendientes de atención.",
            style: TextStyle(color: Colors.white38, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _OperatorHeader extends StatelessWidget {
  final OperatorModel operator;
  const _OperatorHeader({required this.operator});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: ColoresApp.rojoPrincipal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: ColoresApp.rojoPrincipal.withOpacity(0.2)),
          ),
          child: const Icon(Icons.support_agent_rounded, color: ColoresApp.rojoPrincipal, size: 28),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "HOLA, ${operator.nombre.split(' ')[0].toUpperCase()}",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1),
            ),
            const Text(
              "Agente de Seguridad Operativa",
              style: TextStyle(color: ColoresApp.textoSecundario, fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const Spacer(),
        const Badge(
          backgroundColor: Colors.greenAccent,
          smallSize: 8,
          child: Text("ACTIVO", style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}