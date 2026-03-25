import 'package:flutter/material.dart';

import '../widgets/contacto_item_widget.dart';
import '../widgets/buscador_contactos_widget.dart';

import 'package:app_seguridadmx/core/services/contactos_phone_service.dart';
import 'package:app_seguridadmx/core/storage/contactos_storage_service.dart';

import 'package:app_seguridadmx/app/tema/colors_app.dart';

class SeleccionarContactosScreen extends StatefulWidget {
  const SeleccionarContactosScreen({super.key});

  @override
  State<SeleccionarContactosScreen> createState() =>
      _SeleccionarContactosScreenState();
}

class _SeleccionarContactosScreenState
    extends State<SeleccionarContactosScreen> {

  List<Map<String, dynamic>> _contactosPhone = [];
  List<Map<String, dynamic>> _contactosSeleccionados = [];

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _cargarContactos();
  }

  Future<void> _cargarContactos() async {

    try {

      final contactosPhone =
          await ContactosPhoneService.obtenerContactosTelefono();

      final contactosGuardados =
          await ContactosStorageService.obtenerContactos();

      final todosLosContactos = [
        ...contactosPhone,
        ...contactosGuardados
      ];

      final contactosUnicos = {
        for (var c in todosLosContactos)
          c['telefono']: c
      }.values.toList();

      for (var contacto in contactosUnicos) {
        contacto['seleccionado'] = contactosGuardados.any(
            (c) => c['telefono'] == contacto['telefono']);
      }

      setState(() {

        _contactosPhone = contactosUnicos
            .where((c) =>
                c['telefono'] != null &&
                c['telefono'] != "Sin teléfono" &&
                (c['telefono'] as String).isNotEmpty)
            .toList();

        _contactosPhone.sort(
            (a, b) => a['nombre'].compareTo(b['nombre']));

        _loading = false;
      });

    } catch (e) {
      print("Error cargando contactos: $e");
      setState(() => _loading = false);
    }
  }

  ///  Toggle selección
  void _toggleContacto(int index) {

    setState(() {

      final contacto = _contactosPhone[index];

      final existe = _contactosSeleccionados.any(
          (c) => c['telefono'] == contacto['telefono']);

      if (existe) {
        _contactosSeleccionados.removeWhere(
            (c) => c['telefono'] == contacto['telefono']);
      } else {
        _contactosSeleccionados.add(contacto);
      }

      _contactosPhone[index]['seleccionado'] =
          !(_contactosPhone[index]['seleccionado'] ?? false);

    });
  }

  ///  Guardar contactos en memoria local
  Future<void> _guardarContactos() async {

    if (_contactosSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Selecciona al menos un contacto")),
      );
      return;
    }

    ///  Límite de seguridad
    if (_contactosSeleccionados.length > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Máximo 5 contactos de emergencia")),
      );
      return;
    }

    setState(() => _saving = true);

    await ContactosStorageService.guardarContactos(
        _contactosSeleccionados);

    setState(() => _saving = false);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    const backgroundDark = Color(0xFF121212);
    const accentRed = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: backgroundDark,

      appBar: AppBar(
      backgroundColor: backgroundDark,
      elevation: 0,
      title: const Text(
        "Seleccionar Contactos", 
        style: TextStyle(
          color: ColoresApp.textoBlanco, 
          fontWeight: FontWeight.bold
        )
      ),
      iconTheme: const IconThemeData(color: ColoresApp.textoBlanco),
    ),

      body: Column(
        children: [

          const BuscadorContactosWidget(),

          const Padding(
            padding: EdgeInsets.all(15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "CONTACTOS DE EMERGENCIA",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _contactosPhone.length,
                    itemBuilder: (_, index) {

                      return ContactoItemWidget(
                        contacto: _contactosPhone[index],
                        onTap: () => _toggleContacto(index),
                      );
                    },
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(25),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _saving ? null : _guardarContactos,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: _saving
                    ? const CircularProgressIndicator(
                        color: Colors.white)
                    : const Icon(Icons.person_add,
                        color: Colors.white),
                label: const Text(
                  "Guardar Contactos",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}