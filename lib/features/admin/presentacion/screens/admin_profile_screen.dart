import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/rutas/rutas_app.dart';
import 'package:app_seguridadmx/features/admin/presentacion/data/admin_repository.dart';
import 'package:app_seguridadmx/features/admin/presentacion/domain/models/admin_stats_model.dart';
import '../widgets/admin_section_label.dart';
import '../widgets/admin_stat_box.dart';
import '../widgets/admin_session_card.dart';
import '../widgets/admin_config_tile.dart';
import '../widgets/admin_profile_avatar_widget.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  Map<String, dynamic>? adminProfile;
  AdminStatsModel? stats;
  bool _isLoading = true;
  final DateTime _startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    final repo = AdminRepository();
    final profileData = await repo.getAdminProfile();
    final statsData = await repo.getStats();
    
    if (mounted) {
      setState(() {
        adminProfile = profileData;
        stats = statsData;
        _isLoading = false;
      });
    }
  }

  static const backgroundDark = ColoresApp.fondoOscuro;
  static const cardColor = ColoresApp.fondoInput;
  static const accentRed = ColoresApp.rojoPrincipal;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    return "$hours h : $minutes m";
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.white10, width: 1),
          ),
          title: const Text(
            "Cerrar Sesión",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            "¿Estás seguro de que deseas cerrar sesión?",
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "CANCELAR",
                style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentRed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRutas.loginUsuario,
                  (route) => false,
                );
              },
              child: const Text(
                "CONFIRMAR",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || adminProfile == null) {
      return const Scaffold(
        backgroundColor: backgroundDark,
        body: Center(child: CircularProgressIndicator(color: accentRed)),
      );
    }

    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Perfil del Administrador",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: accentRed, width: 2),
                    ),
                    child: Center(
                      child: AdminProfileAvatarWidget(
                        imageUrl: adminProfile!["avatarUrl"] ?? "https://ui-avatars.com/api/?name=${adminProfile!['nombre']}&background=E63946&color=fff",
                      ),
                    ),
                  ),
                  Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: backgroundDark, width: 3),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            Text(
              adminProfile!["nombre"] ?? "N/A",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(
              "Correo: ${adminProfile!["email"]}  •  Rol: ${adminProfile!["rol"]}",
              style: const TextStyle(
                  color: accentRed,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, color: Colors.green, size: 8),
                  SizedBox(width: 8),
                  Text(
                    "EN SERVICIO",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                AdminStatBox(
                  label: "FINALIZADAS HOY",
                  value: stats?.attendedToday.toString() ?? "0",
                  sub: "Institucional",
                  color: Colors.green,
                ),
                const SizedBox(width: 15),
                AdminStatBox(
                  label: "ALERTAS ACTIVAS",
                  value: stats?.activeAlerts.toString() ?? "0",
                  sub: "En vivo",
                  color: accentRed,
                ),
              ],
            ),

            const SizedBox(height: 30),

            const AdminSectionLabel(text: "SESIÓN ACTUAL"),

            AdminSessionCard(
              icon: Icons.access_time_filled,
              title: "Tiempo de Turno",
              sub: "Criterio de actividad real",
              value: _formatDuration(
                DateTime.now().difference(_startTime),
              ),
            ),

            const SizedBox(height: 12),

            AdminSessionCard(
              icon: Icons.timer,
              title: "Promedio de Respuesta",
              sub: "Meta institucional: < 45s",
              value: "38s", 
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutConfirmation(context),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "Cerrar Sesión",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentRed,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Versión del App: 1.0 Professional",
              style: TextStyle(color: Colors.white24, fontSize: 10),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}