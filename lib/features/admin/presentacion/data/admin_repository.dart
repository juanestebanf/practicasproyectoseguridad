import 'package:app_seguridadmx/core/api/api_client.dart';
import 'package:app_seguridadmx/core/api/api_endpoints.dart';
import '../domain/models/admin_stats_model.dart';
import '../domain/models/alert_model.dart';
import '../domain/models/operator_model.dart';

class AdminRepository {
  static final AdminRepository _instance = AdminRepository._internal();
  factory AdminRepository() => _instance;
  AdminRepository._internal();

  final ApiClient _apiClient = ApiClient();

  // 🔹 OBTENER ALERTAS ACTIVAS
  Future<List<AlertModel>> getActiveAlerts() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.activeAlerts);
      final List data = response.data;
      return data.map((json) => AlertModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // 🔹 OBTENER OPERADORES REALES
  Future<List<OperatorModel>> getOperators() async {
    try {
      final response = await _apiClient.dio.get('/users?rol=operador');
      final List data = response.data;
      return data.map((json) => OperatorModel(
        id: json['id'],
        nombre: json['nombre'],
        telefono: json['telefono'] ?? 'N/A',
        activo: json['active'],
      )).toList();
    } catch (e) {
      return [];
    }
  }

  // 🔹 ASIGNAR OPERADOR
  Future<bool> assignOperator(String alertId, String operatorId) async {
    try {
      await _apiClient.dio.patch(
        '${ApiEndpoints.alerts}/$alertId/assign-operator',
        data: {'operatorId': operatorId},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // 🔹 APROBAR REPORTE
  Future<bool> approveReport(String alertId) async {
    try {
      await _apiClient.dio.patch('${ApiEndpoints.alerts}/$alertId/approve');
      return true;
    } catch (e) {
      return false;
    }
  }

  // 🔹 RECHAZAR REPORTE
  Future<bool> rejectReport(String alertId, String feedback) async {
    try {
      await _apiClient.dio.patch(
        '${ApiEndpoints.alerts}/$alertId/reject',
        data: {'feedback': feedback},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // 🔹 ESTADÍSTICAS REALES
  Future<AdminStatsModel> getStats() async {
    try {
      final response = await _apiClient.dio.get('${ApiEndpoints.alerts}/summary');
      final data = response.data;
      return AdminStatsModel(
        activeOperators: data['activeOperators'] ?? 0,
        attendedToday: data['attendedToday'] ?? 0,
        activeAlerts: data['activeAlerts'] ?? 0,
      );
    } catch (e) {
      return AdminStatsModel(activeOperators: 0, attendedToday: 0, activeAlerts: 0);
    }
  }

  // 🔹 PERFIL DEL ADMINISTRADOR
  Future<Map<String, dynamic>?> getAdminProfile() async {
    try {
      final response = await _apiClient.dio.get('/users/profile');
      return response.data;
    } catch (e) {
      return null;
    }
  }

  // 🔹 OBTENER ALERTAS FINALIZADAS
  Future<List<AlertModel>> getFinalizedAlerts() async {
    try {
      final response = await _apiClient.dio.get('${ApiEndpoints.alerts}/finalized');
      final List data = response.data;
      return data.map((json) => AlertModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // 🔹 ACTIVAR/DESACTIVAR OPERADOR
  Future<bool> toggleOperatorStatus(String operatorId, bool currentStatus) async {
    try {
      await _apiClient.dio.patch('/users/$operatorId', data: {'active': !currentStatus});
      return true;
    } catch(e) {
      return false;
    }
  }
}