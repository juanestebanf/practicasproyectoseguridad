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

  final String? reporteFinal;

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
    this.evidencias = const [],
    this.finalizada = false,
  });

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
      evidencias: evidencias ?? this.evidencias,
      finalizada: finalizada ?? this.finalizada,
    );
  }
}