import 'package:app_seguridadmx/core/api/api_client.dart';
import 'package:app_seguridadmx/core/api/api_endpoints.dart';

class ContactosStorageService {
  static final ApiClient _apiClient = ApiClient();

  /// Obtener todos los contactos SOS
  static Future<List<Map<String, dynamic>>> obtenerContactos() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.contacts);
      final List data = response.data;
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error al obtener contactos: $e');
      return [];
    }
  }

  /// Agregar un nuevo contacto
  static Future<void> agregarContacto(Map<String, dynamic> contacto) async {
    try {
      await _apiClient.dio.post(ApiEndpoints.contacts, data: contacto);
    } catch (e) {
      throw Exception('Error al agregar contacto: $e');
    }
  }

  /// Actualizar un contacto existente
  static Future<void> actualizarContacto(String id, Map<String, dynamic> contacto) async {
    try {
      await _apiClient.dio.put('${ApiEndpoints.contacts}/$id', data: contacto);
    } catch (e) {
      throw Exception('Error al actualizar contacto: $e');
    }
  }

  /// Eliminar un contacto
  static Future<void> eliminarContacto(String id) async {
    try {
      await _apiClient.dio.delete('${ApiEndpoints.contacts}/$id');
    } catch (e) {
      throw Exception('Error al eliminar contacto: $e');
    }
  }

  /// Guardar múltiples contactos (Batch)
  static Future<void> guardarContactos(List<Map<String, dynamic>> contactos) async {
    for (var contacto in contactos) {
      // Si el contacto ya tiene ID, podríamos actualizarlo, 
      // pero aquí parece que se guardan como nuevos o se sincronizan.
      // Por simplicidad para el fix, los agregamos.
      await agregarContacto(contacto);
    }
  }
}