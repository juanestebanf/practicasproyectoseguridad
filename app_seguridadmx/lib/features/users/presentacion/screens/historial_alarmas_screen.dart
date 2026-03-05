import 'package:flutter/material.dart';
import '../widgets/alerta_historial_item.dart';
import 'package:app_seguridadmx/features/users/presentacion/widgets/usuario_bottom_nav_widget.dart';
import 'package:app_seguridadmx/features/users/presentacion/widgets/header_home_widget.dart';
import 'package:app_seguridadmx/core/services/alerta_service.dart';
import 'package:app_seguridadmx/core/models/alerta_model.dart';

class HistorialAlarmasScreen extends StatefulWidget {
  const HistorialAlarmasScreen({super.key});

  @override
  State<HistorialAlarmasScreen> createState() =>
      _HistorialAlarmasScreenState();
}

class _HistorialAlarmasScreenState extends State<HistorialAlarmasScreen> {
  String filtro = "TODAS";
  String searchText = "";

  late List<AlertaModel> alertas;

  @override
  void initState() {
    super.initState();
    // Carga inicial desde el servicio
    alertas = AlertaService.obtenerHistorial();
  }

  /// LÓGICA DE FILTRADO CORREGIDA
  List<AlertaModel> get alertasFiltradas {
    return alertas.where((alerta) {
      // 1. Normalizamos a mayúsculas para comparar sin errores de caja
      final tipoAlertaUpper = alerta.tipoAlerta.toUpperCase();
      final filtroUpper = filtro.toUpperCase();

      // 2. Match de Filtro (Chip): Usamos contains para que "PÚBLICA" 
      // coincida con "Alarma Pública"
      final matchFiltro = filtro == "TODAS" || tipoAlertaUpper.contains(filtroUpper);

      // 3. Match de Buscador: Busca en el tipo de emergencia (ROBO, etc)
      final query = searchText.toLowerCase();
      final matchSearch = searchText.isEmpty ||
          alerta.tipoEmergencia.toLowerCase().contains(query) ||
          alerta.tipoAlerta.toLowerCase().contains(query);

      return matchFiltro && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            const HeaderHomeWidget(),

            /// BUSCADOR
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Buscar por emergencia...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1A1A1A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    searchText = val;
                  });
                },
              ),
            ),

            /// FILTROS (CHIPS)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFiltroChip("TODAS"),
                  const SizedBox(width: 10),
                  _buildFiltroChip("PÚBLICA"),
                  const SizedBox(width: 10),
                  _buildFiltroChip("PRIVADA"),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// LISTA DE ALERTAS
            Expanded(
              child: alertasFiltradas.isEmpty
                  ? const Center(
                      child: Text(
                        "No se encontraron alertas",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: alertasFiltradas.length,
                      itemBuilder: (_, index) {
                        return AlertaHistorialItem(
                          alerta: alertasFiltradas[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const UsuarioBottomNavWidget(currentIndex: 2),
    );
  }

  /// WIDGET PARA LOS CHIPS DE FILTRO
  Widget _buildFiltroChip(String label) {
    final bool isSelected = filtro == label;
    const Color accentRed = Color(0xFFE53935);
    const Color cardDark = Color(0xFF1A1A1A);

    return GestureDetector(
      onTap: () {
        setState(() {
          filtro = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? accentRed : cardDark,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? accentRed : Colors.white10,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentRed.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}