import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Asegúrate de tener intl para la fecha
import '../data/admin_fake_repository.dart';
import '../domain/models/alert_model.dart';
import 'alert_detail_screen.dart';

class HistorialAlertasScreen extends StatefulWidget {
  const HistorialAlertasScreen({super.key});

  @override
  State<HistorialAlertasScreen> createState() => _HistorialAlertasScreenState();
}

class _HistorialAlertasScreenState extends State<HistorialAlertasScreen> {
  final _repository = AdminFakeRepository();
  final TextEditingController _searchController = TextEditingController();

  List<AlertModel> _alerts = [];
  List<AlertModel> _filteredAlerts = [];

  @override
  void initState() {
    super.initState();
    _loadAlerts();
    _searchController.addListener(_filterAlerts);
  }

  void _loadAlerts() {
    _alerts = _repository.getFinalizedAlerts();
    _filteredAlerts = _alerts;
  }

  void _filterAlerts() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredAlerts = _alerts.where((alert) {
        return alert.id.toLowerCase().contains(query) ||
            alert.tipoEmergencia.toLowerCase().contains(query) ||
            (alert.operadorId ?? "").toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    const backgroundDark = Color(0xFF0D0D0D);
    const cardColor = Color(0xFF161616);
    const accentRed = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Historial de Alertas",
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1
          ),
        ),
      ),
      body: Column(
        children: [
          /// 🔎 Buscador Estilizado
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: "Buscar por ID, tipo o operador...",
                hintStyle: const TextStyle(color: Colors.white30),
                prefixIcon: const Icon(Icons.search_rounded, color: accentRed, size: 20),
                filled: true,
                fillColor: cardColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: accentRed.withOpacity(0.5)),
                ),
              ),
            ),
          ),

          /// 📋 Lista de Alertas
          Expanded(
            child: _filteredAlerts.isEmpty
                ? const Center(
                    child: Text(
                      "No se encontraron resultados",
                      style: TextStyle(color: Colors.white30),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _filteredAlerts.length,
                    itemBuilder: (context, index) {
                      final alert = _filteredAlerts[index];
                      // Formateo de fecha rápido para la card
                      final String dia = DateFormat('dd').format(alert.fechaCreacion);
                      final String mes = DateFormat('MMM').format(alert.fechaCreacion).toUpperCase();

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AlertDetailScreen(alert: alert),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                /// Columna de Fecha (Icono visual)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.03),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(dia, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                                      Text(mes, style: const TextStyle(color: accentRed, fontWeight: FontWeight.bold, fontSize: 10)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),

                                /// Información de la Alerta
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        alert.tipoEmergencia,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.tag, size: 12, color: Colors.white30),
                                          Text(
                                            " ID: ${alert.id}",
                                            style: const TextStyle(color: Colors.white30, fontSize: 12),
                                          ),
                                          const SizedBox(width: 10),
                                          const Icon(Icons.support_agent_rounded, size: 12, color: Colors.white30),
                                          Text(
                                            " ${alert.operadorId ?? 'N/A'}",
                                            style: const TextStyle(color: Colors.white30, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                /// Flecha estilizada
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white10,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}