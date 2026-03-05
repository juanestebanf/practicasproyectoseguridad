import '../domain/models/admin_stats_model.dart';
import '../domain/models/alert_model.dart';
import '../domain/models/operator_model.dart';
import '../domain/models/alert_event.dart';
import '../domain/models/admin_stats_model.dart';
import '../domain/models/admin_session_stats.dart';


class AdminFakeRepository {
  static final AdminFakeRepository _instance =
      AdminFakeRepository._internal();

  factory AdminFakeRepository() {
    return _instance;
  }

  AdminFakeRepository._internal();

  // 🔹 OPERADORES
  final List<OperatorModel> _operators = [
    OperatorModel(
      id: "op1",
      nombre: "Carlos Mendez",
      telefono: "0991111111",
      activo: true,
    ),
    OperatorModel(
      id: "op2",
      nombre: "Ana Torres",
      telefono: "0992222222",
      activo: true,
    ),
    OperatorModel(
      id: "op3",
      nombre: "Luis Herrera",
      telefono: "0993333333",
      activo: false,
    ),
  ];

  // 🔹 ALERTAS
  final List<AlertModel> _alerts = [
    // 🟡 Alerta en progreso
    AlertModel(
      id: "a1",
      tipoEmergencia: "INCENDIO ESTRUCTURAL",
      fechaCreacion: DateTime.now().subtract(const Duration(hours: 1)),
      estado: AlertStatus.en_progreso,
      esPublica: true,
      usuarioId: "user1",
      operadorId: "op1",
      ubicacion: "Av. 18 de Noviembre, Loja",
      reporteUrl: null,
      historial: [
        AlertEvent(
          tipo: AlertEventType.cambioEstado,
          fecha: DateTime.now().subtract(const Duration(minutes: 5)),
          descripcion: "Estado cambiado a En progreso",
        ),
        AlertEvent(
          tipo: AlertEventType.asignada,
          fecha: DateTime.now().subtract(const Duration(minutes: 10)),
          descripcion: "Asignada al operador op1",
        ),
        AlertEvent(
          tipo: AlertEventType.creada,
          fecha: DateTime.now().subtract(const Duration(hours: 1)),
          descripcion: "Alerta creada",
        ),
      ],
    ),

    // 🟢 Alerta finalizada (para historial)
    AlertModel(
      id: "a2",
      tipoEmergencia: "ROBO A DOMICILIO",
      fechaCreacion: DateTime.now().subtract(const Duration(days: 1)),
      estado: AlertStatus.finalizada,
      esPublica: true,
      usuarioId: "user2",
      operadorId: "op2",
      ubicacion: "Calle Bolívar, Loja",
      reporteUrl: "reporte_a2.pdf",
      historial: [
        AlertEvent(
          tipo: AlertEventType.cambioEstado,
          fecha: DateTime.now().subtract(const Duration(hours: 2)),
          descripcion: "Estado cambiado a Finalizada",
        ),
        AlertEvent(
          tipo: AlertEventType.reporteSubido,
          fecha: DateTime.now().subtract(const Duration(hours: 3)),
          descripcion: "Reporte oficial subido",
        ),
        AlertEvent(
          tipo: AlertEventType.cambioEstado,
          fecha: DateTime.now().subtract(const Duration(hours: 5)),
          descripcion: "Estado cambiado a En progreso",
        ),
        AlertEvent(
          tipo: AlertEventType.asignada,
          fecha: DateTime.now().subtract(const Duration(hours: 6)),
          descripcion: "Asignada al operador op2",
        ),
        AlertEvent(
          tipo: AlertEventType.creada,
          fecha: DateTime.now().subtract(const Duration(days: 1)),
          descripcion: "Alerta creada",
        ),
      ],
    ),
  ];

  // 🔹 Obtener todas (dashboard)
  List<AlertModel> getActiveAlerts() {
    return _alerts
        .where((a) => a.estado != AlertStatus.finalizada)
        .toList();
  }

  // 🔹 Obtener solo finalizadas (historial)
  List<AlertModel> getFinalizedAlerts() {
    return _alerts
        .where((a) => a.estado == AlertStatus.finalizada)
        .toList()
      ..sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
  }

  // 🔹 Asignar operador
  void assignOperator(String alertId, String operadorId) {
    final alert = _alerts.firstWhere((a) => a.id == alertId);

    alert.operadorId = operadorId;
    alert.estado = AlertStatus.en_progreso;

    alert.historial.addAll([
      AlertEvent(
        tipo: AlertEventType.asignada,
        fecha: DateTime.now(),
        descripcion: "Asignada al operador $operadorId",
      ),
      AlertEvent(
        tipo: AlertEventType.cambioEstado,
        fecha: DateTime.now(),
        descripcion: "Estado cambiado a En progreso",
      ),
    ]);
  }

  // 🔹 Finalizar alerta (flujo real completo)
  void finalizeAlert(String alertId, String reporteUrl) {
    final alert = _alerts.firstWhere((a) => a.id == alertId);

    // Guardar reporte
    alert.reporteUrl = reporteUrl;

    // Evento: reporte subido
    alert.historial.add(
      AlertEvent(
        tipo: AlertEventType.reporteSubido,
        fecha: DateTime.now(),
        descripcion: "Reporte oficial subido",
      ),
    );

    // Cambiar estado
    alert.estado = AlertStatus.finalizada;

    // Evento: cambio de estado
    alert.historial.add(
      AlertEvent(
        tipo: AlertEventType.cambioEstado,
        fecha: DateTime.now(),
        descripcion: "Estado cambiado a Finalizada",
      ),
    );
  }

  // 🔹 OPERADORES
  List<OperatorModel> getOperators() {
    return _operators;
  }

  void toggleOperatorStatus(String id) {
    final operator = _operators.firstWhere((op) => op.id == id);
    operator.activo = !operator.activo;
  }

  void addOperator(OperatorModel operator) {
    _operators.add(operator);
  }

  // 🔹 STATS
  AdminStatsModel getStats() {
    return AdminStatsModel(
      activeOperators: _operators.where((o) => o.activo).length,
      attendedToday: 86,
      activeAlerts:
          _alerts.where((a) => a.estado == AlertStatus.pendiente).length,
    );
  }
  AdminSessionStats getSessionStats() {
    return AdminSessionStats(
      attendedToday: _alerts.length,
      efficiency: 98,
      responseTime: 32,
      shiftStart: DateTime.now().subtract(const Duration(hours: 6)),
    );
  }

  // 🔹 PERFIL DEL ADMINISTRADOR (Nuevo método agregado)
  Map<String, dynamic> getAdminProfile() {
    return {
      "id": "AD-001",
      "nombre": "Juan Fuentes",
      "rol": "ADMINISTRADOR",
      "avatarUrl": "https://www.w3schools.com/howto/img_avatar.png",
    };
  }
    
}