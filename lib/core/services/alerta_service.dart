import 'package:app_seguridadmx/core/models/alerta_model.dart';
import 'package:app_seguridadmx/core/api/api_client.dart';
import 'package:app_seguridadmx/core/api/api_endpoints.dart';

class AlertaService {
  final ApiClient _apiClient = ApiClient();

  /// Enviar alerta real al backend
  Future<String?> enviarAlerta({
    required String tipoEmergencia,
    required String tipoAlerta,
    required double lat,
    required double lng,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.alerts,
        data: {
          'titulo': tipoEmergencia,
          'descripcion': 'Alerta generada desde el app: $tipoAlerta',
          'prioridad': 'ALTA', // Default
          'ubicacion': 'Ubicación actual',
          'lat': lat,
          'lng': lng,
        },
      );
      return response.data['id']?.toString();
    } catch (e) {
      return null;
    }
  }

  /// Obtener historial del ciudadano logueado (REAL)
  Future<List<AlertaModel>> fetchUserHistory() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.alertHistory);
      final List data = response.data;
      return data.map((json) => AlertaModel.fromJson(json)).toList();
    } catch (e) {
      print("Error en fetchUserHistory: $e");
      return [];
    }
  }

  /// Verificar alerta activa
  Future<bool> verificarAlertaActiva() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.activeAlerts);
      final List data = response.data;
      // Si hay alguna alerta activa retornamos true
      return data.isNotEmpty;
    } catch (e) {
      return false; 
    }
  }

  /// Obtener alertas cercanas
  Future<List<AlertaModel>> fetchNearbyAlerts(double lat, double lng) async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.activeAlerts);
      final List data = response.data;
      return data.map((json) => AlertaModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Cancelar alerta
  Future<bool> cancelarAlerta(String id) async {
    try {
      await _apiClient.dio.patch('${ApiEndpoints.alerts}/$id/cancel');
      return true;
    } catch (e) {
      return false;
    }
  }
}