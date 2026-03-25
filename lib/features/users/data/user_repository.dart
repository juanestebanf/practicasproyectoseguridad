import 'package:app_seguridadmx/core/api/api_client.dart';

class UserRepository {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final response = await _apiClient.dio.get('/users/profile');
      return response.data;
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      await _apiClient.dio.patch('/users/profile', data: data);
      return true;
    } catch (e) {
      return false;
    }
  }
}
