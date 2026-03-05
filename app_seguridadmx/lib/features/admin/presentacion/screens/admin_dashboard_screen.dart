import 'package:flutter/material.dart';
import '../widgets/stat_card_widget.dart';
import '../widgets/alert_card_widget.dart';
import '../data/admin_fake_repository.dart';
import 'package:app_seguridadmx/features/admin/presentacion/domain/models/alert_model.dart';
import 'asignar_operador_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late List<AlertModel> alerts;
  final repository = AdminFakeRepository();
  AlertStatus? selectedFilter;

  @override
  void initState() {
    super.initState();
    alerts = repository.getActiveAlerts();
  }

  Widget _buildFilterChip(String label, AlertStatus? status) {
    final isSelected = selectedFilter == status;
    const accentRed = Color(0xFFE53935);

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            selectedFilter = status;
          });
        },
        selectedColor: accentRed,
        backgroundColor: const Color(0xFF1E1414),
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[300],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Aplicamos el filtro a la lista de datos
    final filteredAlerts = alerts.where((alert) {
      if (selectedFilter == null) {
        return alert.estado != AlertStatus.finalizada;
      }
      return alert.estado == selectedFilter;
    }).toList();

    final stats = repository.getStats();
    const backgroundDark = Color(0xFF0D0D0D);
    const accentRed = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark,
        elevation: 0,
        title: const Text("Loja Alerta", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 📊 Estadísticas
            Row(
              children: [
                StatCardWidget(
                  label: "OPERADORES",
                  value: stats.activeOperators.toString(),
                  subtext: "Activos",
                  icon: Icons.sensors,
                  color: Colors.green,
                ),
                const SizedBox(width: 15),
                StatCardWidget(
                  label: "ATENDIDAS HOY",
                  value: stats.attendedToday.toString(),
                  subtext: "+15%",
                  icon: Icons.check_circle_outline,
                  color: accentRed,
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                const Text(
                  "Gestión de Alertas",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: accentRed,
                  child: Text(filteredAlerts.length.toString(), style: const TextStyle(color: Colors.white, fontSize: 10)),
                )
              ],
            ),
            const SizedBox(height: 15),
            
            /// 🔍 Filtros
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFilterChip("Activas", null),
                  _buildFilterChip("Pendientes", AlertStatus.pendiente),
                  _buildFilterChip("En progreso", AlertStatus.en_progreso),
                  _buildFilterChip("Finalizadas", AlertStatus.finalizada),
                ],
              ),
            ),
            const SizedBox(height: 10),

            /// 🚨 Lista Mapeada
            ...filteredAlerts.map((alert) => AlertCardWidget(
                  alert: alert, // ✅ Pasamos la alerta completa para navegación
                  type: alert.tipoEmergencia,
                  location: alert.ubicacion,
                  time: _formatTime(alert.fechaCreacion),
                  icon: _getIconForAlertType(alert.tipoEmergencia),
                  status: alert.estado,
                  onAssign: () async {
                    if (alert.estado == AlertStatus.pendiente) {
                      final selectedOperatorId = await Navigator.push<String>(
                        context,
                        MaterialPageRoute(builder: (_) => AsignarOperadorScreen(alert: alert)),
                      );
                      if (selectedOperatorId != null) {
                        setState(() {
                          alert.estado = AlertStatus.en_progreso;
                          alert.operadorId = selectedOperatorId;
                        });
                      }
                    } else if (alert.estado == AlertStatus.en_progreso) {
                      setState(() {
                        alert.estado = AlertStatus.finalizada;
                      });
                    }
                  },
                )).toList(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime date) => "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

  IconData _getIconForAlertType(String type) {
    switch (type.toLowerCase()) {
      case 'incendio': return Icons.local_fire_department;
      case 'emergencia médica': return Icons.medical_services;
      case 'robo': return Icons.security;
      case 'accidente': return Icons.car_crash;
      default: return Icons.warning;
    }
  }
}