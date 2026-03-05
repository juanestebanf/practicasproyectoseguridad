import 'package:flutter/material.dart';
import '../widgets/admin_section_label.dart';
import '../widgets/admin_stat_box.dart';
import '../widgets/admin_session_card.dart';
import '../widgets/admin_config_tile.dart';
import '../widgets/admin_profile_avatar_widget.dart';
import 'package:app_seguridadmx/features/admin/presentacion/data/admin_fake_repository.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  static const backgroundDark = Color(0xFF0D0D0D);
  static const cardColor = Color(0xFF1A1313);
  static const accentRed = Color(0xFFE53935);

  // 🛠 Función para formatear la duración del turno
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    return "$hours h : $minutes m";
  }

  // 🚪 Función para mostrar el diálogo de confirmación
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white10, width: 1),
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
            // Botón Cancelar
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "CANCELAR",
                style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),
              ),
            ),
            // Botón Confirmar
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentRed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/login-usuario",
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
    final repo = AdminFakeRepository();
    final admin = repo.getAdminProfile();
    final sessionStats = repo.getSessionStats();

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

            /// Avatar
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
                        imageUrl: admin["avatarUrl"],
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
              admin["nombre"],
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(
              "ID: ${admin["id"]}  •  ${admin["rol"]}",
              style: const TextStyle(
                  color: accentRed,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            /// Estado (Online)
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

            /// Stats dinámicos reales
            Row(
              children: [
                AdminStatBox(
                  label: "ALERTAS HOY",
                  value: sessionStats.attendedToday.toString(),
                  sub: "+12%",
                  color: Colors.green,
                ),
                const SizedBox(width: 15),
                AdminStatBox(
                  label: "EFICIENCIA",
                  value: "${sessionStats.efficiency}%",
                  sub: "✓",
                  color: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 30),

            const AdminSectionLabel(text: "SESIÓN ACTUAL"),

            /// Tiempo de turno dinámico
            AdminSessionCard(
              icon: Icons.access_time_filled,
              title: "Tiempo de Turno",
              sub: "Cálculo basado en inicio de sesión",
              value: _formatDuration(
                DateTime.now().difference(sessionStats.shiftStart),
              ),
            ),

            const SizedBox(height: 12),

            /// Promedio de respuesta dinámico
            AdminSessionCard(
              icon: Icons.timer,
              title: "Promedio de Respuesta",
              sub: "Meta institucional: < 45s",
              value: "${sessionStats.responseTime}s",
            ),

            const SizedBox(height: 30),

            /// Botón de Cerrar Sesión con Confirmación
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
              "Versión del App: 0.9",
              style: TextStyle(color: Colors.white24, fontSize: 10),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}