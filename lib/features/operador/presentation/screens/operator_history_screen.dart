import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/app/widgets/premium_widgets.dart';
import 'package:app_seguridadmx/features/operador/models/operator_alert_model.dart';
import 'package:app_seguridadmx/features/operador/services/operator_alert_service.dart';
import 'package:app_seguridadmx/features/operador/presentation/widgets/operator_history_card.dart';
import 'package:app_seguridadmx/features/operador/presentation/widgets/operator_bottom_nav_widget.dart';
import 'package:app_seguridadmx/rutas/rutas_app.dart';

class OperatorHistoryScreen extends StatefulWidget {
  const OperatorHistoryScreen({super.key});

  @override
  State<OperatorHistoryScreen> createState() => _OperatorHistoryScreenState();
}

class _OperatorHistoryScreenState extends State<OperatorHistoryScreen> {
  final OperatorAlertService _service = OperatorAlertService();
  final TextEditingController _searchController = TextEditingController();
  
  List<OperatorAlertModel> _alerts = [];
  List<OperatorAlertModel> _filteredAlerts = [];
  bool _loading = true;
  String _stateFilter = "TODAS";

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _searchController.addListener(_applyFilters);
  }

  Future<void> _loadHistory() async {
    setState(() => _loading = true);
    final alerts = await _service.fetchAlertHistory();
    if (mounted) {
      setState(() {
        _alerts = alerts;
        _applyFilters();
        _loading = false;
      });
    }
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredAlerts = _alerts.where((alert) {
        final matchesQuery = alert.id.toLowerCase().contains(query) || 
                           alert.titulo.toLowerCase().contains(query) ||
                           alert.ubicacion.toLowerCase().contains(query);
        
        final matchesState = _stateFilter == "TODAS" || 
                           (_stateFilter == "FINALIZADAS" && alert.finalizada) ||
                           (_stateFilter == "EN PROGRESO" && !alert.finalizada);
                           
        return matchesQuery && matchesState;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondoOscuro,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "ARCHIVO DE ALERTAS",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 2),
        ),
      ),
      bottomNavigationBar: const OperatorBottomNavWidget(currentIndex: 1),
      body: RefreshIndicator(
        onRefresh: _loadHistory,
        color: ColoresApp.rojoPrincipal,
        child: Column(
          children: [
            /// 🔍 BUSCADOR Y FILTRO SIMPLIFICADO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                borderRadius: 20,
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: "Buscar por ID, título o ubicación...",
                    hintStyle: TextStyle(color: Colors.white24, fontSize: 13),
                    prefixIcon: Icon(Icons.search_rounded, color: ColoresApp.rojoPrincipal, size: 20),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            /// 🏷️ FILTROS RÁPIDOS (SINGLE ROW)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: ["TODAS", "FINALIZADAS", "EN PROGRESO"].map((filter) {
                  final isSelected = _stateFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(filter, style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white38,
                        fontSize: 10,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                      )),
                      selected: isSelected,
                      onSelected: (s) {
                        setState(() => _stateFilter = filter);
                        _applyFilters();
                      },
                      selectedColor: ColoresApp.rojoPrincipal,
                      backgroundColor: Colors.white.withOpacity(0.05),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide.none),
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: PremiumSectionTitle(
                title: "Registros",
                subtitle: "Historial operativo",
                icon: Icons.folder_open_rounded,
              ),
            ),

            /// 📋 LISTA
            Expanded(
              child: _loading
                  ? _buildShimmerList()
                  : _filteredAlerts.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _filteredAlerts.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: OperatorHistoryCard(
                                alert: _filteredAlerts[index],
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRutas.operatorAlertDetail,
                                    arguments: _filteredAlerts[index].id,
                                  );
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_delete_outlined, size: 80, color: Colors.white.withOpacity(0.05)),
          const SizedBox(height: 16),
          const Text(
            "Archivo sin coincidencias",
            style: TextStyle(color: Colors.white38, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 4,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: ShimmerLoading(width: double.infinity, height: 120, borderRadius: 20),
      ),
    );
  }
}