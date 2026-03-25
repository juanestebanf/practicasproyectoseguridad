import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/app/widgets/premium_widgets.dart';
import 'package:app_seguridadmx/features/users/presentacion/widgets/usuario_bottom_nav_widget.dart';
import 'package:app_seguridadmx/features/users/presentacion/widgets/header_home_widget.dart';
import 'package:app_seguridadmx/core/services/alerta_service.dart';
import 'package:app_seguridadmx/core/models/alerta_model.dart';
import '../widgets/alerta_historial_item.dart';

class HistorialAlarmasScreen extends StatefulWidget {
  const HistorialAlarmasScreen({super.key});

  @override
  State<HistorialAlarmasScreen> createState() =>
      _HistorialAlarmasScreenState();
}

class _HistorialAlarmasScreenState extends State<HistorialAlarmasScreen> {
  final AlertaService _alertaService = AlertaService();
  String filtro = "TODAS";
  String searchText = "";

  List<AlertaModel> _alertas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final results = await _alertaService.fetchUserHistory();
    if (mounted) {
      setState(() {
        _alertas = results;
        _isLoading = false;
      });
    }
  }

  List<AlertaModel> get alertasFiltradas {
    return _alertas.where((alerta) {
      final tipoAlertaUpper = alerta.tipoAlerta.toUpperCase();
      final filtroUpper = filtro.toUpperCase();
      final matchFiltro = filtro == "TODAS" || tipoAlertaUpper.contains(filtroUpper);

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
      backgroundColor: ColoresApp.fondoOscuro,
      body: SafeArea(
        child: Column(
          children: [
            const HeaderHomeWidget(),
            
            /// 🔍 BUSCADOR PREMIUM
            Padding(
              padding: const EdgeInsets.all(16),
              child: GlassContainer(
                padding: EdgeInsets.zero,
                borderRadius: 15,
                child: TextField(
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "Buscar por emergencia...",
                    hintStyle: const TextStyle(color: Colors.white30),
                    prefixIcon: const Icon(Icons.search, color: ColoresApp.rojoPrincipal),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  onChanged: (val) => setState(() => searchText = val),
                ),
              ),
            ),

            /// 🏷️ FILTROS (CHIPS PREMIUM)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
            ),

            const SizedBox(height: 20),
            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: PremiumSectionTitle(
                title: "Actividad Reciente",
                subtitle: "Historial completo de tus reportes",
              ),
            ),

            const SizedBox(height: 10),

            /// 📋 LISTA CON REFRESH Y SHIMMER
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadData,
                color: ColoresApp.rojoPrincipal,
                backgroundColor: ColoresApp.fondoInput,
                child: _isLoading
                    ? _buildShimmerList()
                    : alertasFiltradas.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: alertasFiltradas.length,
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: AlertaHistorialItem(
                                  alerta: alertasFiltradas[index],
                                ),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const UsuarioBottomNavWidget(currentIndex: 2),
    );
  }

  Widget _buildEmptyState() {
    return ListView( // Usamos ListView para que el RefreshIndicator funcione
      children: const [
        SizedBox(height: 100),
        Center(
          child: Column(
            children: [
              Icon(Icons.history_toggle_off, size: 64, color: Colors.white10),
              SizedBox(height: 16),
              Text(
                "No hay alertas registradas",
                style: TextStyle(color: ColoresApp.textoSecundario, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: ShimmerLoading(width: double.infinity, height: 100, borderRadius: 18),
      ),
    );
  }

  Widget _buildFiltroChip(String label) {
    final bool isSelected = filtro == label;
    return GestureDetector(
      onTap: () => setState(() => filtro = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? ColoresApp.rojoPrincipal : ColoresApp.fondoInput,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: ColoresApp.rojoPrincipal.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : ColoresApp.textoSecundario,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}