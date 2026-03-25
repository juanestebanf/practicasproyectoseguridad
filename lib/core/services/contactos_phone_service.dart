import 'package:flutter_contacts/flutter_contacts.dart';

class ContactosPhoneService {

  static Future<List<Map<String, dynamic>>> obtenerContactosTelefono() async {

    try {

      final permiso = await FlutterContacts.requestPermission();

      if (!permiso) return [];

      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: false,
        withGroups: false,
      );

      final lista = contacts
          .where((c) =>
              c.displayName != null &&
              c.phones.isNotEmpty)
          .map((contacto) {

        final numero = contacto.phones.isNotEmpty
            ? contacto.phones.first.number
            : "Sin teléfono";

        return {
          "nombre": contacto.displayName ?? "Sin nombre",
          "telefono": numero,
          "iniciales": _generarIniciales(
              contacto.displayName ?? ""),
          "seleccionado": false
        };

      }).toList();

      print("Contactos leídos: ${lista.length}");

      return lista;

    } catch (e) {

      print("Error leyendo contactos: $e");
      return [];
    }
  }

  static String _generarIniciales(String nombre) {

    if (nombre.trim().isEmpty) return "??";

    final partes = nombre.trim().split(RegExp(r'\s+'));

    if (partes.length >= 2) {
      return (partes[0][0] + partes[1][0]).toUpperCase();
    }

    return nombre[0].toUpperCase();
  }
}