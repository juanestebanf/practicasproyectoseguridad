import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/app/widgets/premium_widgets.dart';
import '../widgets/opcion_alarma_card.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black26,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'CONFIGURAR ALERTA',
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.w900,
            fontSize: 14,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          /// 🌑 DEGRADADO DE FONDO SEGURO
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.5,
                  colors: [
                    ColoresApp.rojoPrincipal.withOpacity(0.05),
                    ColoresApp.fondoOscuro,
                  ],
                ),
              ),
            ),
          ),
          
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 120),

                      /// 🏷️ BADGE PREMIUM
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: ColoresApp.rojoPrincipal.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: ColoresApp.rojoPrincipal.withOpacity(0.2)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.gpp_maybe, color: ColoresApp.rojoPrincipal, size: 14),
                            SizedBox(width: 8),
                            Text(
                              'SISTEMA DE RESPUESTA INMEDIATA',
                              style: TextStyle(
                                color: ColoresApp.rojoPrincipal,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Confirmar Emergencia',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Seleccione el tipo y alcance de su reporte para movilizar los recursos adecuados.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColoresApp.textoSecundario,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 40),

                      /// 🛡️ ALCANCE DE ALERTA (GLASS)
                      PremiumSectionTitle(title: 'Alcance del Reporte', icon: Icons.radar),
                      const SizedBox(height: 16),
                      
                      OpcionAlarmaCard(
                        id: 'publica',
                        titulo: 'Alarma Pública (Nivel 1)',
                        descripcion: 'Autoridades y usuarios cercanos (40m) serán notificados.',
                        icono: Icons.campaign_rounded,
                        colorBase: ColoresApp.rojoPrincipal,
                        estaSeleccionada: _tipoSeleccionado == 'publica',
                        onTap: () => setState(() => _tipoSeleccionado = 'publica'),
                      ),

                      const SizedBox(height: 16),

                      OpcionAlarmaCard(
                        id: 'privada',
                        titulo: 'Alarma Privada (Nivel 2)',
                        descripcion: 'Solo sus contactos de confianza recibirán su ubicación.',
                        icono: Icons.security,
                        colorBase: ColoresApp.info,
                        estaSeleccionada: _tipoSeleccionado == 'privada',
                        onTap: () => setState(() => _tipoSeleccionado = 'privada'),
                      ),

                      const SizedBox(height: 40),

                      /// ⚠️ TIPO DE EMERGENCIA
                      PremiumSectionTitle(title: 'Tipo de Incidente', icon: Icons.category_outlined),
                      const SizedBox(height: 16),

                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _chipEmergencia('Robo', Icons.security),
                          _chipEmergencia('Incendio', Icons.local_fire_department),
                          _chipEmergencia('Violencia', Icons.warning_amber_rounded),
                          _chipEmergencia('Emergencia Médica', Icons.medical_services_rounded),
                          _chipEmergencia('Sospechoso', Icons.visibility_rounded),
                        ],
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              /// 🚀 BOTÓN DE ACCIÓN ACCIONABLE (GLOW)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton(
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
                    backgroundColor: ColoresApp.rojoPrincipal,
                    shadowColor: ColoresApp.rojoPrincipal.withOpacity(0.5),
                    elevation: 15,
                    minimumSize: const Size(double.infinity, 64),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bolt_rounded, color: Colors.white),
                      const SizedBox(width: 12),
                      Text(
                        'ACTIVAR PROTOCOLO',
                        style: TextStyle(
                          color: _emergenciaSeleccionada == null ? Colors.white30 : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chipEmergencia(String label, IconData icon) {
    final bool seleccionada = _emergenciaSeleccionada == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _emergenciaSeleccionada = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: seleccionada ? ColoresApp.rojoPrincipal : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: seleccionada ? ColoresApp.rojoPrincipal : Colors.white.withOpacity(0.08),
            width: 1.5,
          ),
          boxShadow: seleccionada ? [
            BoxShadow(
              color: ColoresApp.rojoPrincipal.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 4),
            )
          ] : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: seleccionada ? Colors.white : ColoresApp.textoSecundario,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: seleccionada ? Colors.white : ColoresApp.textoSecundario,
                fontSize: 14,
                fontWeight: seleccionada ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}