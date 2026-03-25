import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/app/widgets/premium_widgets.dart';
import 'package:app_seguridadmx/features/admin/presentacion/data/admin_repository.dart';
import 'package:app_seguridadmx/features/admin/presentacion/domain/models/admin_stats_model.dart';
import 'package:app_seguridadmx/features/admin/presentacion/domain/models/alert_model.dart';
import '../widgets/stat_card_widget.dart';
import '../widgets/alert_card_widget.dart';
import 'asignar_operador_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final repository = AdminRepository();
  AlertStatus? selectedFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondoOscuro,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => setState(() {}),
          color: ColoresApp.rojoPrincipal,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                /// 🛡️ PREMIUM HEADER
                _AdminHeader(),

                const SizedBox(height: 30),

                /// 📊 Estadísticas Reales (GLASS)
                FutureBuilder<AdminStatsModel>(
                  future: repository.getStats(),
                  builder: (context, snapshot) {
                    final stats = snapshot.data;
                    return Row(
                      children: [
                        StatCardWidget(
                          label: "OPERADORES",
                          value: stats?.activeOperators.toString() ?? "0",
                          subtext: "Activos",
                          icon: Icons.sensors_rounded,
                          color: Colors.greenAccent,
                        ),
                        const SizedBox(width: 15),
                        StatCardWidget(
                          label: "ALERTA HOY",
                          value: stats?.attendedToday.toString() ?? "0",
                          subtext: "Hoy",
                          icon: Icons.check_circle_rounded,
                          color: ColoresApp.rojoPrincipal,
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 40),

                const PremiumSectionTitle(
                  title: "Gestión de Incidentes",
                  subtitle: "Monitoreo en tiempo real de la red",
                  icon: Icons.dashboard_customize_rounded,
                ),

                const SizedBox(height: 20),
                
                /// 🚨 LISTA DE ALERTAS ACTIVAS
                FutureBuilder<List<AlertModel>>(
                  future: repository.getActiveAlerts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(color: ColoresApp.rojoPrincipal),
                      ));
                    }
                    
                    final alerts = snapshot.data ?? [];
                    final filteredAlerts = alerts.where((alert) {
                      if (selectedFilter == null) {
                        return alert.estado != AlertStatus.finalizada;
                      }
                      return alert.estado == selectedFilter;
                    }).toList();

                    if (filteredAlerts.isEmpty) {
                      return _buildEmptyActiveState();
                    }

                    return Column(
                      children: filteredAlerts.map((alert) => _PremiumAlertCard(
                        alert: alert,
                        onAssign: () async {
                          if (alert.estado == AlertStatus.pendiente) {
                             await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => AsignarOperadorScreen(alert: alert)),
                            );
                            setState(() {});
                          }
                        },
                      )).toList(),
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyActiveState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: const Column(
        children: [
          Icon(Icons.verified_user_rounded, color: Colors.greenAccent, size: 50),
          SizedBox(height: 16),
          Text(
            "Sistema Seguro",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(
            "No hay alertas pendientes en este momento.",
            style: TextStyle(color: Colors.white38, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AdminHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ColoresApp.rojoPrincipal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: ColoresApp.rojoPrincipal.withOpacity(0.2)),
          ),
          child: const Icon(Icons.admin_panel_settings_rounded, color: ColoresApp.rojoPrincipal, size: 28),
        ),
        const SizedBox(width: 15),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "SEGURIDAD",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 2),
            ),
            Text(
              "Panel de Administración General",
              style: TextStyle(color: ColoresApp.textoSecundario, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.notifications_none_rounded, color: Colors.white.withOpacity(0.5)),
        ),
      ],
    );
  }
}

class _PremiumAlertCard extends StatelessWidget {
  final AlertModel alert;
  final VoidCallback onAssign;

  const _PremiumAlertCard({required this.alert, required this.onAssign});

  @override
  Widget build(BuildContext context) {
    final bool isActionable = alert.estado == AlertStatus.pendiente;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getColorForStatus(alert.estado).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_getIconForType(alert.tipoEmergencia), color: _getColorForStatus(alert.estado), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert.tipoEmergencia.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        alert.ubicacion,
                        style: const TextStyle(color: Colors.white30, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isActionable)
            GestureDetector(
              onTap: onAssign,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: ColoresApp.rojoPrincipal.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assignment_ind_rounded, color: ColoresApp.rojoPrincipal, size: 16),
                    SizedBox(width: 8),
                    Text(
                      "ASIGNAR OPERADOR AHORA",
                      style: TextStyle(color: ColoresApp.rojoPrincipal, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getColorForStatus(AlertStatus status) {
    switch (status) {
      case AlertStatus.pendiente: return ColoresApp.rojoPrincipal;
      case AlertStatus.en_progreso: return Colors.orangeAccent;
      case AlertStatus.finalizada: return Colors.greenAccent;
      default: return Colors.blueAccent;
    }
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'incendio': return Icons.local_fire_department_rounded;
      case 'emergencia médica': return Icons.medical_services_rounded;
      case 'robo': return Icons.security_rounded;
      default: return Icons.warning_amber_rounded;
    }
  }
}