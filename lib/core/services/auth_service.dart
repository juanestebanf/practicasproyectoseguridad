import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';

class AuthService {
  static final ApiClient _apiClient = ApiClient();

  static Future<String> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', data['access_token']);
      await prefs.setString('user_rol', data['user']['rol']);
      await prefs.setString('user_id', data['user']['id']);
      return data['user']['rol'];
    } on DioException catch (e) {
      throw _parseError(e);
    } catch (e) {
      throw Exception('Error inesperado al intentar iniciar sesión');
    }
  }

  /// Check if an email is already registered
  static Future<bool> isEmailRegistered(String email) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.checkEmail,
        data: {'email': email},
      );
      return response.data['exists'] == true;
    } on DioException catch (e) {
      // If endpoint doesn't exist, try to check during registration
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Check if a cédula is already registered
  static Future<bool> isCedulaRegistered(String cedula) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.checkCedula,
        data: {'cedula': cedula},
      );
      return response.data['exists'] == true;
    } on DioException catch (e) {
      // If endpoint doesn't exist, try to check during registration
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> register({
    required String nombre, 
    required String cedula, 
    required String email, 
    required String telefono, 
    required String password, 
    String? rol,
    bool checkDuplicates = true,
  }) async {
    try {
      // Check for duplicates if enabled
      if (checkDuplicates) {
        if (cedula.isNotEmpty) {
          final cedulaExists = await isCedulaRegistered(cedula);
          if (cedulaExists) {
            throw Exception('Esta cédula ya está registrada');
          }
        }
        
        final emailExists = await isEmailRegistered(email);
        if (emailExists) {
          throw Exception('Este correo electrónico ya está registrado');
        }
      }

      final Map<String, dynamic> requestData = {
        'nombre': nombre,
        'cedula': cedula.isNotEmpty ? cedula : null,
        'email': email,
        'telefono': telefono.isNotEmpty ? telefono : null,
        'password': password,
      };
      requestData.removeWhere((key, value) => value == null);
      if (rol != null && rol.isNotEmpty) {
        requestData['rol'] = rol;
      }

      final response = await _apiClient.dio.post(
        ApiEndpoints.register,
        data: requestData,
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } on DioException catch (e) {
      throw _parseError(e);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  static Future<String> forgotPassword(String email) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.forgotPassword,
        data: {'email': email},
      );
      return response.data['message'] ?? 'Se ha enviado un código de recuperación';
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  static Future<String> resetPassword(String token, String newPassword) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.resetPassword,
        data: {
          'token': token,
          'newPassword': newPassword,
        },
      );
      return response.data['message'] ?? 'Contraseña actualizada con éxito';
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  static Exception _parseError(DioException e) {
    if (e.response?.data != null && e.response?.data['message'] != null) {
      final message = e.response?.data['message'];
      if (message is List) {
        return Exception(message.join('\n'));
      }
      return Exception(message.toString());
    }
    return Exception('Error de conexión o credenciales incorrectas');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('user_rol');
    await prefs.remove('user_id');
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('access_token');
  }

  static Future<String?> getUserRol() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_rol');
  }
}