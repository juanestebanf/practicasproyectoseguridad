import 'alert_event.dart';

enum AlertStatus {
  pendiente,
  en_progreso,
  despachada,
  finalizada,
}

class AlertModel {
  final String id;
  final String tipoEmergencia;
  final DateTime fechaCreacion;
  final String ubicacion;

  AlertStatus estado;

  final bool esPublica;
  final String usuarioId;

  String? operadorId;   // null si no está asignada
  String? reporteUrl;   // null hasta que se suba el PDF

  final List<AlertEvent> historial;

  AlertModel({
    required this.id,
    required this.tipoEmergencia,
    required this.fechaCreacion,
    required this.ubicacion,
    required this.estado,
    required this.esPublica,
    required this.usuarioId,
    this.operadorId,
    this.reporteUrl,
    List<AlertEvent>? historial,
  }) : historial = historial ?? [];

  // Método útil para actualizar estado sin mutar el objeto
  AlertModel copyWith({
    String? id,
    String? tipoEmergencia,
    DateTime? fechaCreacion,
    String? ubicacion,
    AlertStatus? estado,
    bool? esPublica,
    String? usuarioId,
    String? operadorId,
    String? reporteUrl,
    List<AlertEvent>? historial,
  }) {
    return AlertModel(
      id: id ?? this.id,
      tipoEmergencia: tipoEmergencia ?? this.tipoEmergencia,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      ubicacion: ubicacion ?? this.ubicacion,
      estado: estado ?? this.estado,
      esPublica: esPublica ?? this.esPublica,
      usuarioId: usuarioId ?? this.usuarioId,
      operadorId: operadorId ?? this.operadorId,
      reporteUrl: reporteUrl ?? this.reporteUrl,
      historial: historial ?? this.historial,
    );
  }
}