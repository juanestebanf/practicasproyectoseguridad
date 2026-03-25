import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_seguridadmx/rutas/rutas_app.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/app/widgets/premium_widgets.dart';

class BotonSOSWidget extends StatefulWidget {
  const BotonSOSWidget({super.key});

  @override
  State<BotonSOSWidget> createState() => _BotonSOSWidgetState();
}

class _BotonSOSWidgetState extends State<BotonSOSWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  double _longPressProgress = 0.0;
  Timer? _timer;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startLongPress() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isPressed = true;
      _longPressProgress = 0.0;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _longPressProgress += 0.05; 
        if (_longPressProgress >= 1.0) {
          _timer?.cancel();
          _emitAlarma();
        }
      });
    });
  }

  void _stopLongPress() {
    _timer?.cancel();
    setState(() {
      _isPressed = false;
      _longPressProgress = 0.0;
    });
  }

  void _emitAlarma() {
    if (mounted) {
      HapticFeedback.heavyImpact();
      Navigator.pushNamed(context, AppRutas.seleccionarAlarma);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onLongPressStart: (_) => _startLongPress(),
          onLongPressEnd: (_) => _stopLongPress(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// 🔴 EFECTOS DE PULSO DUAL
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColoresApp.rojoPrincipal.withOpacity(0.12),
                  ),
                ),
              ),
              
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColoresApp.rojoPrincipal.withOpacity(0.08),
                  ),
                ),
              ),

              /// ⚙️ ANILLO DE PROGRESO
              SizedBox(
                width: 310,
                height: 310,
                child: CircularProgressIndicator(
                  value: _longPressProgress,
                  strokeWidth: 4,
                  strokeCap: StrokeCap.round,
                  color: ColoresApp.rojoPrincipal,
                  backgroundColor: Colors.white.withOpacity(0.05),
                ),
              ),

              /// 🚨 BOTÓN PRINCIPAL
              AnimatedScale(
                scale: _isPressed ? 0.94 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: 245,
                  height: 245,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: ColoresApp.rojoPrincipal.withOpacity(0.6),
                        blurRadius: 40,
                        spreadRadius: 2,
                      ),
                    ],
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ColoresApp.rojoBrillante,
                        ColoresApp.rojoPrincipal,
                        Color(0xFF8B0000),
                      ],
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 80, color: Colors.white),
                      SizedBox(height: 12),
                      Text(
                        'SOS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        'MANTENER PRESIONADO',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 30),
        
        /// 💡 INSTRUCCIÓN PREMIUM
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            borderRadius: 15,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline, size: 16, color: ColoresApp.rojoPrincipal),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'En caso de emergencia real, mantén presionado el botón hasta completar el círculo.',
                    textAlign: TextAlign.start,
                    style: TextStyle(color: ColoresApp.textoSecundario, fontSize: 11, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}