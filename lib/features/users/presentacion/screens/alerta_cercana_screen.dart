import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/core/models/alerta_model.dart';

class AlertaCercanaScreen extends StatelessWidget {
  final AlertaModel alerta;

  const AlertaCercanaScreen({
    super.key,
    required this.alerta,
  });

  @override
  Widget build(BuildContext context) {
    const backgroundDark = Color(0xFF0D0D0D);
    const accentRed = Color(0xFFE53935);
    const cardColor = Color(0xFF1A1313);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Icono superior
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: accentRed.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.warning_amber_rounded,
                      color: accentRed, size: 50),
                ),
              ),

              const SizedBox(height: 25),

              Text(
                alerta.tipoEmergencia.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: accentRed,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.3,
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: accentRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: accentRed.withOpacity(0.3)),
                ),
                child: Text(
                  alerta.sector.toUpperCase(),
                  style: const TextStyle(
                      color: accentRed,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 15),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoColumn(
                            "DISTANCIA",
                            alerta.distancia
                                .toStringAsFixed(0),
                            " metros"),
                        _buildInfoColumn(
                            "TIPO",
                            alerta.tipoAlerta,
                            ""),
                      ],
                    ),
                    const SizedBox(height: 20),

                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(15),
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        color: Colors.white10,
                        child: Stack(
                          children: [
                            Image.network(
                              'https://static-maps.yandex.ru/1.x/?lang=en_US&ll=${alerta.lng},${alerta.lat}&z=14&l=map&size=450,300',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                            const Center(
                              child: Icon(Icons.location_on,
                                  color: accentRed,
                                  size: 40),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              _buildActionButton(
                label: "VER UBICACIÓN",
                icon: Icons.map,
                color: const Color(0xFF2D3243),
                onPressed: () {},
              ),

              const SizedBox(height: 12),

              _buildActionButton(
                label: "LLAMAR",
                icon: Icons.phone,
                color: ColoresApp.exito.withOpacity(0.8),
                onPressed: () {},
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Ignorar",
                    style:
                        TextStyle(color: ColoresApp.textoSecundario, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(
      String label, String value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.grey,
                fontSize: 11,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: unit,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
          elevation: 0,
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
    );
  }
}