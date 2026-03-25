import 'package:app_seguridadmx/core/api/api_client.dart';
import 'package:app_seguridadmx/core/api/api_endpoints.dart';

class UserService {
  static final ApiClient _apiClient = ApiClient();

  /// Obtener el perfil del usuario actual
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.profile);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Error al obtener el perfil: $e');
    }
  }

  /// Actualizar el perfil del usuario actual
  static Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      await _apiClient.dio.patch(ApiEndpoints.profile, data: data);
    } catch (e) {
      throw Exception('Error al actualizar el perfil: $e');
    }
  }
}
