import 'package:flutter/material.dart';
import 'package:app_seguridadmx/core/services/alertas_service_notificacion.dart';
import 'package:app_seguridadmx/core/models/alerta_model.dart';
import '../widgets/alerta_card_widget.dart';
import 'alerta_cercana_screen.dart';
import 'package:app_seguridadmx/rutas/rutas_app.dart';

class NotificacionesScreen extends StatefulWidget {
  const NotificacionesScreen({super.key});

  @override
  State<NotificacionesScreen> createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  final AlertasServiceNotificacion _notificacionService = AlertasServiceNotificacion();
  List<AlertaModel> alertas = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadAlertas();
  }

  Future<void> _loadAlertas() async {
    setState(() => loading = true);
    final results = await _notificacionService.obtenerAlertas();
    if (mounted) {
      setState(() {
        alertas = results;
        loading = false;
      });
    }
  }

  void _abrirDetalle(AlertaModel alerta) {
    setState(() {
      alertas = alertas.map((a) {
        if (a.id == alerta.id) {
          return a.copyWith(leida: true);
        }
        return a;
      }).toList();
    });

    Navigator.pushNamed(
        context,
        AppRutas.alertaCercana,
        arguments: alerta,
    );
  }

  @override
  Widget build(BuildContext context) {
    const backgroundDark = Color(0xFF0D0D0D);

    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark,
        elevation: 0,
        title: const Text(
          "Notificaciones",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: loading 
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : alertas.isEmpty
              ? const Center(
                  child: Text(
                    "No hay alertas disponibles",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: RefreshIndicator(
                    onRefresh: _loadAlertas,
                    child: ListView(
                      children: alertas
                          .map((alerta) => AlertaCardWidget(
                                alerta: alerta,
                                onTap: () => _abrirDetalle(alerta),
                              ))
                          .toList(),
                    ),
                  ),
                ),
    );
  }
}