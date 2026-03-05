import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ContactosStorageService {

  static const String _keyContactos = "contactos_sos";

  /// Guardar contactos SOS en memoria local
  static Future<void> guardarContactos(
      List<Map<String, dynamic>> contactos) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        _keyContactos,
        jsonEncode(contactos));
  }

  /// Obtener contactos SOS guardados
  static Future<List<Map<String, dynamic>>> obtenerContactos() async {

    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(_keyContactos);

    if (data == null) return [];

    return List<Map<String, dynamic>>.from(
        jsonDecode(data));
  }

  /// Eliminar todos los contactos SOS (futuro botón emergencia)
  static Future<void> limpiarContactos() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_keyContactos);
  }
}