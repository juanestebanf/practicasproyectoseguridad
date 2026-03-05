import 'package:flutter/material.dart';
import 'accion_rapida_item_widget.dart';
import '../screens/seleccionar_contactos_screen.dart';
import 'package:app_seguridadmx/rutas/rutas_app.dart';

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
            icon: Icons.contact_phone_outlined,
            label: 'Contactos',
            onTap: () {
              Navigator.pushNamed(context, '/seleccionar-contactos');
            },
          ),
        ],
      ),
    );
  }
}