import 'package:flutter/material.dart';

import 'package:app_seguridadmx/features/operador/models/operator_alert_model.dart';
import 'package:app_seguridadmx/features/operador/services/operator_alert_service.dart';

import 'package:app_seguridadmx/features/operador/presentation/widgets/operator_history_card.dart';
import 'package:app_seguridadmx/features/operador/presentation/widgets/operator_bottom_nav_widget.dart';
import 'package:app_seguridadmx/features/operador/presentation/widgets/operator_section_title.dart';

import 'package:app_seguridadmx/rutas/rutas_app.dart';

class OperatorHistoryScreen extends StatefulWidget {
  const OperatorHistoryScreen({super.key});

  @override
  State<OperatorHistoryScreen> createState() => _OperatorHistoryScreenState();
}

class _OperatorHistoryScreenState extends State<OperatorHistoryScreen> {

  final OperatorAlertService _service = OperatorAlertService();

  List<OperatorAlertModel> _alerts = [];

  bool _loading = true;

  String _priorityFilter = "TODAS";
  String _stateFilter = "TODOS";

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  /// CARGAR HISTORIAL

  Future<void> _loadHistory() async {

    final alerts = await _service.fetchAlertHistory();

    setState(() {
      _alerts = alerts;
      _loading = false;
    });
  }

  /// FILTRO

  List<OperatorAlertModel> get _filteredAlerts {

    return _alerts.where((alert) {

      final priorityMatch =
          _priorityFilter == "TODAS" || alert.prioridad == _priorityFilter;

      final stateMatch =
          _stateFilter == "TODOS" || alert.estado == _stateFilter;

      return priorityMatch && stateMatch;

    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    const bgColor = Color(0xFF0D0D0D);

    return Scaffold(

      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text("Historial de alertas"),
      ),

      bottomNavigationBar: const OperatorBottomNavWidget(
        currentIndex: 1,
      ),

      body: _loading

          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE53935),
              ),
            )

          : ListView(
              padding: const EdgeInsets.all(16),
              children: [

                const OperatorSectionTitle(
                  title: "Filtros",
                ),

                const SizedBox(height: 10),

                _buildFilters(),

                const SizedBox(height: 24),

                const OperatorSectionTitle(
                  title: "Alertas atendidas",
                ),

                const SizedBox(height: 10),

                if (_filteredAlerts.isEmpty)

                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "No hay registros",
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  )

                else

                  ..._filteredAlerts.map(

                    (alert) => OperatorHistoryCard(

                      alert: alert,

                      onTap: () {

                        Navigator.pushNamed(
                          context,
                          AppRutas.operatorAlertDetail,
                          arguments: alert.id,
                        );

                      },

                    ),

                  )
              ],
            ),
    );
  }

  /// FILTROS

  Widget _buildFilters() {

    return Column(
      children: [

        Row(
          children: [

            Expanded(
              child: DropdownButtonFormField<String>(

                dropdownColor: const Color(0xFF161616),

                value: _priorityFilter,

                decoration: const InputDecoration(
                  labelText: "Prioridad",
                  labelStyle: TextStyle(color: Colors.white70),
                ),

                items: const [

                  DropdownMenuItem(value: "TODAS", child: Text("Todas")),
                  DropdownMenuItem(value: "ALTA", child: Text("Alta")),
                  DropdownMenuItem(value: "MEDIA", child: Text("Media")),
                  DropdownMenuItem(value: "BAJA", child: Text("Baja")),

                ],

                onChanged: (value) {

                  setState(() {
                    _priorityFilter = value!;
                  });

                },
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: DropdownButtonFormField<String>(

                dropdownColor: const Color(0xFF161616),

                value: _stateFilter,

                decoration: const InputDecoration(
                  labelText: "Estado",
                  labelStyle: TextStyle(color: Colors.white70),
                ),

                items: const [

                  DropdownMenuItem(value: "TODOS", child: Text("Todos")),
                  DropdownMenuItem(value: "FINALIZADA", child: Text("Finalizada")),
                  DropdownMenuItem(value: "CANCELADA", child: Text("Cancelada")),

                ],

                onChanged: (value) {

                  setState(() {
                    _stateFilter = value!;
                  });

                },
              ),
            ),
          ],
        )
      ],
    );
  }
}