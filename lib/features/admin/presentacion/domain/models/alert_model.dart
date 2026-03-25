import 'alert_event.dart';

enum AlertStatus {
  pendiente,
  en_progreso,
  autoridad_asignada,
  esperando_aprobacion,
  finalizada,
  rechazada,
}

class AlertModel {
  final String id;
  final String tipoEmergencia;
  final DateTime fechaCreacion;
  final String ubicacion;
  AlertStatus estado;
  final bool esPublica;
  final String usuarioId;
  String? operadorId;
  String? reporteUrl;
  String? reporteTexto;
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
    this.reporteTexto,
    List<AlertEvent>? historial,
  }) : historial = historial ?? [];

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] ?? 'N/A',
      tipoEmergencia: json['titulo'] ?? 'Desconocida',
      fechaCreacion: json['fecha'] != null ? DateTime.parse(json['fecha']) : DateTime.now(),
      ubicacion: json['ubicacion'] ?? 'Ubicación no disponible',
      estado: _parseStatus(json['estado'] ?? 'pendiente'),
      esPublica: true,
      usuarioId: json['ciudadano'] != null ? json['ciudadano']['id'] : 'unknown',
      operadorId: json['operador'] != null ? json['operador']['id'] : null,
      reporteUrl: json['reporte_file_path'],
      reporteTexto: json['reporte_texto'],
    );
  }

  static AlertStatus _parseStatus(String status) {
    switch (status) {
      case 'pendiente': return AlertStatus.pendiente;
      case 'en_progreso': return AlertStatus.en_progreso;
      case 'autoridad_asignada': return AlertStatus.autoridad_asignada;
      case 'esperando_aprobacion': return AlertStatus.esperando_aprobacion;
      case 'finalizada': return AlertStatus.finalizada;
      case 'rechazada': return AlertStatus.rechazada;
      default: return AlertStatus.pendiente;
    }
  }

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
    String? reporteTexto,
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
      reporteTexto: reporteTexto ?? this.reporteTexto,
      historial: historial ?? this.historial,
    );
  }
}