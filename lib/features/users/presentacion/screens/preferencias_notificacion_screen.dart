import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';

class PreferenciasNotificacionScreen extends StatefulWidget {
  const PreferenciasNotificacionScreen({super.key});

  @override
  State<PreferenciasNotificacionScreen> createState() => _PreferenciasNotificacionScreenState();
}

class _PreferenciasNotificacionScreenState extends State<PreferenciasNotificacionScreen> {
  // 1. Definimos el estado inicial de cada opción
  bool sonidoPanico = true;
  bool vibracionContinua = true;
  bool ubicacionAuto = true;
  bool alertasPublicas = false;

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
            color: ColoresApp.textoBlanco,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: ColoresApp.textoBlanco),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          _buildOptionGroup("ALERTAS CRÍTICAS", [
            _notifItem(
              "Sonido de Pánico",
              "Emitir sonido fuerte incluso en modo silencio",
              sonidoPanico,
              (val) => setState(() => sonidoPanico = val),
            ),
            _notifItem(
              "Vibración Continua",
              "Vibrar hasta que se confirme la recepción",
              vibracionContinua,
              (val) => setState(() => vibracionContinua = val),
            ),
          ]),
          const SizedBox(height: 20),
          _buildOptionGroup("PRIVACIDAD", [
            _notifItem(
              "Ubicación Automática",
              "Compartir coordenadas al activar alerta",
              ubicacionAuto,
              (val) => setState(() => ubicacionAuto = val),
            ),
            _notifItem(
              "Alertas Públicas",
              "Notificar a usuarios cercanos sobre tu emergencia",
              alertasPublicas,
              (val) => setState(() => alertasPublicas = val),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildOptionGroup(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFFE53935),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  // 2. Agregamos el parámetro 'onChanged' al método para recibir la función de cambio
  Widget _notifItem(String t, String s, bool v, Function(bool) onChanged) {
    return SwitchListTile(
      activeColor: const Color(0xFFE53935),
      title: Text(t, style: const TextStyle(color: Colors.white, fontSize: 15)),
      subtitle: Text(s, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      value: v,
      onChanged: onChanged, // 3. Aquí se ejecuta el setState() definido arriba
    );
  }
}