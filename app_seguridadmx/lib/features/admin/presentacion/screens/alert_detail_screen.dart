import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_seguridadmx/features/admin/presentacion/domain/models/alert_model.dart';
import 'package:app_seguridadmx/features/admin/presentacion/domain/models/alert_event.dart';

class AlertDetailScreen extends StatelessWidget {
  final AlertModel alert;

  const AlertDetailScreen({
    super.key,
    required this.alert,
  });

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy • HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    const accentRed = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        // ✅ Forzamos que la flecha y los iconos sean blancos
        iconTheme: const IconThemeData(color: Colors.white), 
        title: const Text(
          "Detalle de Alerta",
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.w600, 
            letterSpacing: 1,
            color: Colors.white, // ✅ Texto del título en blanco
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔴 Header con Tipo y Estado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    alert.tipoEmergencia,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900, // ✅ Corregido: de .black a .w900
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                _buildStatusBadge(alert.estado),
              ],
            ),

            const SizedBox(height: 30),

            // 📋 Sección Información General
            _buildSectionContainer(
              title: "Información General",
              child: Column(
                children: [
                  _buildInfoRow(Icons.location_on_rounded, "Ubicación", alert.ubicacion),
                  _buildDivider(),
                  _buildInfoRow(Icons.calendar_today_rounded, "Creación", _formatDate(alert.fechaCreacion)),
                  _buildDivider(),
                  _buildInfoRow(Icons.person_pin_rounded, "ID Usuario", alert.usuarioId),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 👤 Sección Operador
            _buildSectionContainer(
              title: "Gestión de Operador",
              child: alert.operadorId == null
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Sin asignar", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                      ),
                    )
                  : _buildInfoRow(Icons.support_agent_rounded, "Operador ID", alert.operadorId!),
            ),

            const SizedBox(height: 25),

            // 📄 Sección Reporte
            _buildSectionContainer(
              title: "Documentación",
              child: alert.reporteUrl == null
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Reporte no disponible", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                      ),
                    )
                  : _buildInfoRow(Icons.picture_as_pdf_rounded, "Reporte PDF", "Ver documento adjunto", isLink: true),
            ),

            const SizedBox(height: 35),

            // 🔥 HISTORIAL TIMELINE
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 20),
              child: Text(
                "LÍNEA DE TIEMPO",
                style: TextStyle(
                  color: accentRed,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 12,
                ),
              ),
            ),

            ...alert.historial.reversed.toList().asMap().entries.map(
              (entry) {
                final index = entry.key;
                final event = entry.value;
                final isLast = index == alert.historial.length - 1;
                return _buildEventTile(event, isLast);
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS DE APOYO ESTÉTICO ---

  Widget _buildSectionContainer({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF161616),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.white38),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: isLink ? Colors.blueAccent : Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => Divider(color: Colors.white.withOpacity(0.05), height: 20);

  Widget _buildEventTile(AlertEvent event, bool isLast) {
    final color = _getColorByType(event.tipo);
    final iconData = _getIconByType(event.tipo);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withOpacity(0.5), width: 2),
                ),
                child: Icon(iconData, size: 16, color: color),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [color.withOpacity(0.5), Colors.white10],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF161616),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.03)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.descripcion,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(event.fecha),
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconByType(AlertEventType tipo) {
    switch (tipo) {
      case AlertEventType.creada: return Icons.add_alert_rounded;
      case AlertEventType.asignada: return Icons.person_add_alt_1_rounded;
      case AlertEventType.cambioEstado: return Icons.published_with_changes_rounded;
      case AlertEventType.reporteSubido: return Icons.file_present_rounded;
      default: return Icons.notifications_rounded;
    }
  }

  Color _getColorByType(AlertEventType tipo) {
    switch (tipo) {
      case AlertEventType.creada: return Colors.greenAccent;
      case AlertEventType.asignada: return Colors.orangeAccent;
      case AlertEventType.cambioEstado: return Colors.blueAccent;
      case AlertEventType.reporteSubido: return Colors.redAccent;
      default: return Colors.grey;
    }
  }

  Widget _buildStatusBadge(AlertStatus status) {
    Color color;
    String text;
    switch (status) {
      case AlertStatus.pendiente: color = Colors.orange; text = "PENDIENTE"; break;
      case AlertStatus.en_progreso: color = Colors.blue; text = "EN CURSO"; break;
      case AlertStatus.despachada: color = Colors.purple; text = "DESPACHADA"; break;
      case AlertStatus.finalizada: color = Colors.green; text = "RESUELTA"; break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1),
      ),
    );
  }
}