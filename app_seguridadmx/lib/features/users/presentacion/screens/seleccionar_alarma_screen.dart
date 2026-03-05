import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import '../widgets/opcion_alarma_card.dart';
import '../widgets/map_controls_widget.dart';
import '../widgets/alerta_activa_card.dart';
import 'mapa_screen.dart';

class SeleccionarAlarmaScreen extends StatefulWidget {
  const SeleccionarAlarmaScreen({super.key});

  @override
  State<SeleccionarAlarmaScreen> createState() =>
      _SeleccionarAlarmaScreenState();
}

class _SeleccionarAlarmaScreenState extends State<SeleccionarAlarmaScreen> {
  String _tipoSeleccionado = 'publica';
  String? _emergenciaSeleccionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondoOscuro,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Seleccionar Alarma',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  /// Etiqueta superior
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(20),
                      border: Border.all(
                          color:
                              Colors.red.withOpacity(0.3)),
                    ),
                    child: const Text(
                      'EMERGENCIA LOJA',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    '¿Qué tipo de emergencia desea reportar?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Seleccione el alcance de la alerta para recibir asistencia inmediata.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14),
                  ),

                  const SizedBox(height: 32),

                  /// ALARMA PÚBLICA
                  OpcionAlarmaCard(
                    id: 'publica',
                    titulo: 'Alarma Pública',
                    descripcion:
                        'Notifica a usuarios en un radio de 40m y a las autoridades locales automáticamente.',
                    icono: Icons.report_problem,
                    colorBase: Colors.red,
                    estaSeleccionada:
                        _tipoSeleccionado == 'publica',
                    onTap: () =>
                        setState(() => _tipoSeleccionado = 'publica'),
                  ),

                  const SizedBox(height: 20),

                  /// ALARMA PRIVADA
                  OpcionAlarmaCard(
                    id: 'privada',
                    titulo: 'Alarma Privada',
                    descripcion:
                        'Notifica únicamente a tus contactos de confianza.',
                    icono: Icons.lock,
                    colorBase: Colors.blue,
                    estaSeleccionada:
                        _tipoSeleccionado == 'privada',
                    onTap: () =>
                        setState(() => _tipoSeleccionado = 'privada'),
                  ),

                  const SizedBox(height: 32),

                  /// TIPO DE EMERGENCIA
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tipo de emergencia',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _chipEmergencia('Robo', Icons.security),
                      _chipEmergencia('Incendio',
                          Icons.local_fire_department),
                      _chipEmergencia('Violencia',
                          Icons.warning_amber_rounded),
                      _chipEmergencia('Emergencia médica',
                          Icons.medical_services),
                      _chipEmergencia('Sospechoso',
                          Icons.visibility),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          /// BOTÓN INFERIOR
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _emergenciaSeleccionada == null
                    ? null
                    : () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MapaScreen(
                              tipoEmergencia: _emergenciaSeleccionada,
                              alcance: _tipoSeleccionado,
                            ),
                            ),
                          );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      ColoresApp.rojoPrincipal,
                  disabledBackgroundColor:
                      Colors.grey.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(
                  Icons.notifications_active,
                  color: Colors.white,
                ),
                label: const Text(
                  'Confirmar Alarma',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipEmergencia(String label, IconData icon) {
    final bool seleccionada =
        _emergenciaSeleccionada == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _emergenciaSeleccionada = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: seleccionada
              ? ColoresApp.rojoPrincipal
              : const Color(0xFF1E1E1E),
          borderRadius:
              BorderRadius.circular(12),
          border: Border.all(
            color: seleccionada
                ? ColoresApp.rojoPrincipal
                : Colors.white12,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}