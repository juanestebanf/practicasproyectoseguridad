import 'dart:io';

import 'package:app_seguridadmx/features/operador/data/operator_repository.dart';
import 'package:app_seguridadmx/features/operador/models/authority_model.dart';
import 'package:app_seguridadmx/features/operador/models/operator_alert_model.dart';
import 'package:app_seguridadmx/features/operador/models/operator_model.dart';

class OperatorAlertService {

  final OperatorRepository _operatorRepo = OperatorRepository();

  /// PERFIL OPERADOR

  Future<OperatorModel> fetchOperatorProfile() async {
    return await _operatorRepo.getOperatorProfile();
  }

  /// ALERTAS ASIGNADAS (Dashboard)

  Future<List<OperatorAlertModel>> fetchAssignedAlerts() async {
    return await _operatorRepo.getAssignedAlerts();
  }

  /// HISTORIAL ALERTAS

  Future<List<OperatorAlertModel>> fetchAlertHistory() async {
    return await _operatorRepo.getOperatorHistory();
  }

  /// DETALLE ALERTA

  Future<OperatorAlertModel?> fetchAlertDetails(String alertId) async {
    return await _operatorRepo.getAlertById(alertId);
  }

  /// ACEPTAR ALERTA

  Future<bool> acceptAlert(String alertId) async {
    return await _operatorRepo.acceptAlert(alertId);
  }

  /// ASIGNAR AUTORIDAD (policia/bomberos/etc)

  Future<bool> assignAuthorityToAlert(
    String alertId,
    AuthorityModel authority,
  ) async {
    return await _operatorRepo.assignAuthority(alertId, authority);
  }

  /// SUBIR EVIDENCIA

  Future<bool> uploadEvidence(String alertId, File file) async {
    return await _operatorRepo.uploadEvidence(alertId, file);
  }

  /// FINALIZAR ALERTA

  Future<bool> closeAlert(String alertId, String report) async {

    if (report.trim().isEmpty) {
      return false;
    }

    return await _operatorRepo.finalizeAlert(alertId, report);
  }

  /// AUTORIDADES DISPONIBLES

  Future<List<AuthorityModel>> getAvailableAuthorities() async {
    return await _operatorRepo.getAuthorities();
  }

}