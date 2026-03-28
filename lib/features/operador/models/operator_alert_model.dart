class OperatorAlertModel {
  final String id;
  final String titulo;
  final String descripcion;
  final String prioridad;
  final String estado;
  final String ubicacion;
  final DateTime fecha;
  final String ciudadano;
  final double lat;
  final double lng;
  final String? operadorAsignado;
  final String? autoridadAsignada;
  final String? reporteFinal; // Maps to reporte_file_path
  final String? reporteTexto; // New text report
  final List<String> evidencias;
  final bool finalizada;

  OperatorAlertModel({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.prioridad,
    required this.estado,
    required this.ubicacion,
    required this.fecha,
    required this.ciudadano,
    required this.lat,
    required this.lng,
    this.operadorAsignado,
    this.autoridadAsignada,
    this.reporteFinal,
    this.reporteTexto,
    this.evidencias = const [],
    this.finalizada = false,
  });

  factory OperatorAlertModel.fromJson(Map<String, dynamic> json) {
    return OperatorAlertModel(
      id: json['id']?.toString() ?? '',
      titulo: json['titulo'] ?? 'Sin título',
      descripcion: json['descripcion'] ?? 'Sin descripción',
      prioridad: json['prioridad'] ?? 'BAJA',
      estado: json['estado'] ?? 'pendiente',
      ubicacion: json['ubicacion'] ?? 'Ubicación no disponible',
      fecha: json['fecha'] != null ? DateTime.parse(json['fecha']) : DateTime.now(),
      ciudadano: (json['ciudadano'] != null && json['ciudadano']['nombre'] != null) 
          ? json['ciudadano']['nombre'] 
          : 'Desconocido',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      operadorAsignado: json['operador'] != null ? json['operador']['id']?.toString() : null,
      autoridadAsignada: json['autoridad'] != null ? json['autoridad']['nombre'] : null,
      reporteFinal: json['reporte_file_path'],
      reporteTexto: json['reporte_texto'],
      evidencias: (json['evidencias'] as List?)?.map((e) => e['file_path'] as String).toList() ?? [],
      finalizada: json['estado'] == 'finalizada',
    );
  }

  OperatorAlertModel copyWith({
    String? titulo,
    String? descripcion,
    String? prioridad,
    String? estado,
    String? ubicacion,
    String? ciudadano,
    double? lat,
    double? lng,
    String? operadorAsignado,
    String? autoridadAsignada,
    String? reporteFinal,
    String? reporteTexto,
    List<String>? evidencias,
    bool? finalizada,
  }) {
    return OperatorAlertModel(
      id: id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      prioridad: prioridad ?? this.prioridad,
      estado: estado ?? this.estado,
      ubicacion: ubicacion ?? this.ubicacion,
      fecha: fecha,
      ciudadano: ciudadano ?? this.ciudadano,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      operadorAsignado: operadorAsignado ?? this.operadorAsignado,
      autoridadAsignada: autoridadAsignada ?? this.autoridadAsignada,
      reporteFinal: reporteFinal ?? this.reporteFinal,
      reporteTexto: reporteTexto ?? this.reporteTexto,
      evidencias: evidencias ?? this.evidencias,
      finalizada: finalizada ?? this.finalizada,
    );
  }
}