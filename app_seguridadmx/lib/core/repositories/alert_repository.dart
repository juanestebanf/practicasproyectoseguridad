import 'dart:io';

import 'package:app_seguridadmx/features/operador/models/operator_alert_model.dart';
import 'package:app_seguridadmx/features/operador/models/operator_model.dart';
import 'package:app_seguridadmx/features/operador/models/authority_model.dart';

class OperatorRepository {

  static final OperatorRepository _instance = OperatorRepository._internal();

  factory OperatorRepository() {
    return _instance;
  }

  OperatorRepository._internal();

  /// OPERADOR SIMULADO

  final OperatorModel _operator = OperatorModel(
    id: "op_001",
    nombre: "Carlos Mendoza",
    rol: "Operador de Emergencias",
    estadisticas: OperatorStats(
      alertasAtendidasHoy: 5,
      eficiencia: 97.5,
      tiempoPromedioRespuesta: "3m 45s",
    ),
  );

  /// AUTORIDADES DISPONIBLES

  final List<AuthorityModel> _authorities = [
    AuthorityModel(
      id: "auth_001",
      nombre: "Policía Nacional",
      tipo: "POLICIA",
    ),
    AuthorityModel(
      id: "auth_002",
      nombre: "Bomberos Loja",
      tipo: "BOMBEROS",
    ),
    AuthorityModel(
      id: "auth_003",
      nombre: "Ambulancia 911",
      tipo: "AMBULANCIA",
    ),
    AuthorityModel(
      id: "auth_004",
      nombre: "Seguridad Ciudadana",
      tipo: "SEGURIDAD",
    ),
  ];

  /// ALERTAS MOCK

  final List<OperatorAlertModel> _alerts = [

    OperatorAlertModel(
      id: 'alert_001',
      titulo: 'Robo en proceso',
      descripcion: 'Sujetos armados ingresando a local comercial.',
      prioridad: 'ALTA',
      estado: 'PENDIENTE',
      ubicacion: 'Av. 24 de Mayo y Mercadillo',
      fecha: DateTime.now().subtract(const Duration(minutes: 5)),
      ciudadano: 'Juan Pérez',
      operadorAsignado: 'op_001',
    ),

    OperatorAlertModel(
      id: 'alert_002',
      titulo: 'Accidente de Tránsito',
      descripcion: 'Choque múltiple, posibles heridos.',
      prioridad: 'ALTA',
      estado: 'AUTORIDAD_ASIGNADA',
      ubicacion: 'Av. Universitaria y Rocafuerte',
      fecha: DateTime.now().subtract(const Duration(minutes: 30)),
      ciudadano: 'María López',
      operadorAsignado: 'op_001',
      autoridadAsignada: 'Bomberos Loja',
    ),

    OperatorAlertModel(
      id: 'alert_003',
      titulo: 'Persona sospechosa',
      descripcion: 'Individuo merodeando viviendas.',
      prioridad: 'BAJA',
      estado: 'FINALIZADA',
      ubicacion: 'Barrio Zamora',
      fecha: DateTime.now().subtract(const Duration(hours: 2)),
      ciudadano: 'Carlos Ruiz',
      operadorAsignado: 'op_001',
      autoridadAsignada: 'Policía Nacional',
      reporteFinal: 'Se verificó la zona. Falsa alarma.',
      finalizada: true,
    ),

  ];

  /// PERFIL OPERADOR

  Future<OperatorModel> getOperatorProfile() async {

    await Future.delayed(const Duration(milliseconds: 300));

    return _operator;
  }

  /// ALERTAS ASIGNADAS

  Future<List<OperatorAlertModel>> getAssignedAlerts() async {

    await Future.delayed(const Duration(milliseconds: 400));

    return _alerts
        .where((a) => a.operadorAsignado == _operator.id && !a.finalizada)
        .toList();
  }

  /// HISTORIAL

  Future<List<OperatorAlertModel>> getOperatorHistory() async {

    await Future.delayed(const Duration(milliseconds: 400));

    return _alerts
        .where((a) => a.operadorAsignado == _operator.id && a.finalizada)
        .toList();
  }

  /// BUSCAR ALERTA

  Future<OperatorAlertModel?> getAlertById(String id) async {

    await Future.delayed(const Duration(milliseconds: 200));

    try {
      return _alerts.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  /// ACEPTAR ALERTA

  Future<bool> acceptAlert(String alertId) async {

    await Future.delayed(const Duration(milliseconds: 400));

    final index = _alerts.indexWhere((a) => a.id == alertId);

    if (index != -1) {

      final oldAlert = _alerts[index];

      _alerts[index] = oldAlert.copyWith(
        estado: "EN_PROCESO",
      );

      return true;
    }

    return false;
  }

  /// ASIGNAR AUTORIDAD

  Future<bool> assignAuthority(String alertId, AuthorityModel authority) async {

    await Future.delayed(const Duration(milliseconds: 500));

    final index = _alerts.indexWhere((a) => a.id == alertId);

    if (index != -1) {

      final oldAlert = _alerts[index];

      _alerts[index] = oldAlert.copyWith(
        autoridadAsignada: authority.nombre,
        estado: "AUTORIDAD_ASIGNADA",
      );

      return true;
    }

    return false;
  }

  /// SUBIR EVIDENCIA (simulado)

  Future<bool> uploadEvidence(String alertId, File file) async {

    await Future.delayed(const Duration(milliseconds: 500));

    return true;
  }

  /// FINALIZAR ALERTA

  Future<bool> finalizeAlert(String alertId, String reporte) async {

    await Future.delayed(const Duration(milliseconds: 500));

    final index = _alerts.indexWhere((a) => a.id == alertId);

    if (index != -1) {

      final oldAlert = _alerts[index];

      _alerts[index] = oldAlert.copyWith(
        reporteFinal: reporte,
        estado: "FINALIZADA",
        finalizada: true,
      );

      return true;
    }

    return false;
  }

  /// AUTORIDADES

  Future<List<AuthorityModel>> getAuthorities() async {

    await Future.delayed(const Duration(milliseconds: 300));

    return _authorities;
  }

}