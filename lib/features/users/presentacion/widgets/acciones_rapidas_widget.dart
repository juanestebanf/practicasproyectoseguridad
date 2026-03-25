import 'package:flutter/material.dart';
import 'accion_rapida_item_widget.dart';
import 'package:app_seguridadmx/rutas/rutas_app.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';

class AccionesRapidasWidget extends StatelessWidget {
  const AccionesRapidasWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AccionRapidaItemWidget(
            icon: Icons.map_outlined,
            label: 'Mapa',
            onTap: () {
              Navigator.pushNamed(context, AppRutas.mapa);
            },
          ),
          AccionRapidaItemWidget(
            icon: Icons.contact_phone_outlined,
            label: 'Contactos',
            onTap: () {
              Navigator.pushNamed(context, AppRutas.gestionarContactos);
            },
          ),
          AccionRapidaItemWidget(
            icon: Icons.history_edu_outlined,
            label: 'Historial',
            onTap: () {
              Navigator.pushNamed(context, AppRutas.historialAlarmas);
            },
          ),
        ],
      ),
    );
  }
}