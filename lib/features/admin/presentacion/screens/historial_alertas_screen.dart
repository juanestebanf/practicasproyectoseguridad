import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/app/widgets/premium_widgets.dart';
import 'package:app_seguridadmx/features/admin/presentacion/data/admin_repository.dart';
import 'package:app_seguridadmx/core/services/auth_service.dart';
import '../domain/models/alert_model.dart';
import 'alert_detail_screen.dart';

class HistorialAlertasScreen extends StatefulWidget {
  const HistorialAlertasScreen({super.key});

  @override
  State<HistorialAlertasScreen> createState() => _HistorialAlertasScreenState();
}

class _HistorialAlertasScreenState extends State<HistorialAlertasScreen> {
  final _repository = AdminRepository();
  final TextEditingController _searchController = TextEditingController();

  List<AlertModel> _alerts = [];
  List<AlertModel> _filteredAlerts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlerts();
    _searchController.addListener(_filterAlerts);
  }

  Future<void> _loadAlerts() async {
    setState(() => _isLoading = true);
    try {
      final alerts = await _repository.getFinalizedAlerts();
      if (mounted) {
        setState(() {
          _alerts = alerts;
          _filteredAlerts = alerts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
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
    return Scaffold(
      backgroundColor: ColoresApp.fondoOscuro,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "REGISTRO HISTÓRICO",
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.w900,
            fontSize: 14,
            letterSpacing: 2
          ),
        ),
      ),
      body: Column(
        children: [
          /// 🔎 BUSCADOR PREMIUM (GLASS)
          Padding(
            padding: const EdgeInsets.all(20),
            child: GlassContainer(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              borderRadius: 20,
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: "Buscar incidente, ID o operador...",
                  hintStyle: TextStyle(color: Colors.white30, fontSize: 13),
                  prefixIcon: Icon(Icons.search_rounded, color: ColoresApp.rojoPrincipal, size: 20),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: PremiumSectionTitle(
              title: "Alertas Finalizadas",
              icon: Icons.history_rounded,
            ),
          ),

          const SizedBox(height: 10),

          /// 📋 LISTA MEJORADA
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: ColoresApp.rojoPrincipal))
              : _filteredAlerts.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: _filteredAlerts.length,
                        itemBuilder: (context, index) {
                          return _AlertHistoryCard(
                            alert: _filteredAlerts[index],
                            onDelete: () => _loadAlerts(),
                          );
                        },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_delete_outlined, color: Colors.white.withOpacity(0.05), size: 100),
          const SizedBox(height: 20),
          const Text(
            "Archivo vacío o sin resultados",
            style: TextStyle(color: Colors.white38, fontSize: 16),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: _loadAlerts,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text("REINTENTAR"),
            style: TextButton.styleFrom(foregroundColor: ColoresApp.rojoPrincipal),
          )
        ],
      ),
    );
  }
}

class _AlertHistoryCard extends StatefulWidget {
  final AlertModel alert;
  final VoidCallback onDelete;
  const _AlertHistoryCard({required this.alert, required this.onDelete});

  @override
  State<_AlertHistoryCard> createState() => _AlertHistoryCardState();
}

class _AlertHistoryCardState extends State<_AlertHistoryCard> {
  String? _rol;

  @override
  void initState() {
    super.initState();
    _checkRol();
  }

  Future<void> _checkRol() async {
    final r = await AuthService.getUserRol();
    if (mounted) setState(() => _rol = r);
  }

  Future<void> _deleteAlert() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1414),
        title: const Text("Eliminar Alerta", style: TextStyle(color: Colors.white)),
        content: const Text("¿Deseas eliminar este registro histório?", style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("CANCELAR")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("ELIMINAR", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      final success = await AdminRepository().deleteAlert(widget.alert.id);
      if (success) {
        widget.onDelete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String dia = DateFormat('dd').format(widget.alert.fechaCreacion);
    final String mes = DateFormat('MMM').format(widget.alert.fechaCreacion).toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AlertDetailScreen(alert: widget.alert))),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  /// 📅 BADGE DE FECHA
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.01)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(dia, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
                        Text(mes, style: const TextStyle(color: ColoresApp.rojoPrincipal, fontWeight: FontWeight.bold, fontSize: 10)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  /// 📋 DETALLES
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.alert.tipoEmergencia.toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 0.5),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 12, color: Colors.white30),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                widget.alert.ubicacion,
                                style: const TextStyle(color: Colors.white30, fontSize: 11),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            "FINALIZADA Y ARCHIVADA",
                            style: TextStyle(color: Colors.green, fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// 🔘 ACCION
                  if (_rol == 'superadmin')
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.white24, size: 20),
                      onPressed: _deleteAlert,
                    )
                  else
                    const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white10, size: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}