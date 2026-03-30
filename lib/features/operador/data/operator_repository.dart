import 'dart:io';
import 'package:dio/dio.dart';
import 'package:app_seguridadmx/core/api/api_client.dart';
import 'package:app_seguridadmx/core/api/api_endpoints.dart';
import 'package:app_seguridadmx/features/operador/models/operator_alert_model.dart';
import 'package:app_seguridadmx/features/operador/models/operator_model.dart';
import 'package:app_seguridadmx/features/operador/models/authority_model.dart';

class OperatorRepository {
  static final OperatorRepository _instance = OperatorRepository._internal();
  factory OperatorRepository() => _instance;
  OperatorRepository._internal();

  final ApiClient _apiClient = ApiClient();

  /// PERFIL DEL OPERADOR (Backend real)
  Future<OperatorModel> getOperatorProfile() async {
    try {
      final profileRes = await _apiClient.dio.get('/users/profile');
      final userData = profileRes.data;
      final userId = userData['id'].toString();
      
      // Obtener estadísticas reales del operador desde el endpoint específico
      int attendedToday = 0;
      double eficiencia = 100.0;
      String tiempoResp = "N/A";

      try {
        final statsRes = await _apiClient.dio.get(ApiEndpoints.myStats);
        attendedToday = statsRes.data['alertasAtendidasHoy'] ?? 0;
        eficiencia = (statsRes.data['eficiencia'] ?? 100.0).toDouble();
        tiempoResp = statsRes.data['tiempoPromedioRespuesta'] ?? 'N/A';
      } catch (e) {
        print("Error cargando estadísticas del operador: $e");
      }

      return OperatorModel(
        id: userId,
        nombre: userData['nombre'] ?? "Operador",
        rol: userData['rol'] ?? "Operador",
        foto: userData['foto'],
        estadisticas: OperatorStats(
          alertasAtendidasHoy: attendedToday,
          eficiencia: eficiencia,
          tiempoPromedioRespuesta: tiempoResp,
        ),
      );
    } catch (e) {
      return OperatorModel(
        id: "op_error",
        nombre: "Error Cargando",
        rol: "Operador",
        estadisticas: OperatorStats(
          alertasAtendidasHoy: 0,
          eficiencia: 0.0,
          tiempoPromedioRespuesta: "N/A",
        ),
      );
    }
  }

  /// ALERTAS ASIGNADAS AL OPERADOR (Dashboard)
  Future<List<OperatorAlertModel>> getAssignedAlerts() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.assignedAlerts);
      final List data = response.data;
      return data.map((json) => OperatorAlertModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  /// HISTORIAL (Todas las asignadas)
  Future<List<OperatorAlertModel>> getOperatorHistory() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.assignedAlerts);
      final List data = response.data;
      return data.map((json) => OperatorAlertModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  /// DETALLE POR ID
  Future<OperatorAlertModel?> getAlertById(String id) async {
    try {
      final response = await _apiClient.dio.get('${ApiEndpoints.alerts}/$id');
      return OperatorAlertModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  /// ACCIÓN: ACEPTAR
  Future<bool> acceptAlert(String alertId) async {
    try {
      await _apiClient.dio.patch('${ApiEndpoints.alerts}/$alertId/accept');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// ACCIÓN: ASIGNAR AUTORIDAD
  Future<bool> assignAuthority(String alertId, AuthorityModel authority) async {
    try {
      await _apiClient.dio.patch(
        '${ApiEndpoints.alerts}/$alertId/assign-authority',
        data: {'authorityId': authority.id},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// ACCIÓN: FINALIZAR (Reporte)
  Future<bool> finalizeAlert(String alertId, String report) async {
    try {
       await _apiClient.dio.patch(
        '${ApiEndpoints.alerts}/$alertId/finalize',
        data: {'report': report},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// ACCIÓN: EVIDENCIA
  Future<bool> uploadEvidence(String alertId, File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });
      await _apiClient.dio.post(
        '${ApiEndpoints.alerts}/$alertId/upload-evidence',
        data: formData,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// CATÁLOGO: AUTORIDADES
  Future<List<AuthorityModel>> getAuthorities() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.authorities);
      final List data = response.data;
      return data.map((json) => AuthorityModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}