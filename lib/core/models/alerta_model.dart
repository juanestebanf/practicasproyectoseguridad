class AlertaModel {
  final String id;
  final String tipoEmergencia;
  final String tipoAlerta; 
  final String sector;
  final double distancia;
  final DateTime fecha;
  final double lat;
  final double lng;
  final bool leida;
  final String estado; 

  AlertaModel({
    required this.id,
    required this.tipoEmergencia,
    required this.tipoAlerta,
    required this.sector,
    required this.distancia,
    required this.fecha,
    required this.lat,
    required this.lng,
    this.leida = false,
    this.estado = "emitida", 
  });

  factory AlertaModel.fromJson(Map<String, dynamic> json) {
    return AlertaModel(
      id: json['id']?.toString() ?? '',
      tipoEmergencia: json['titulo'] ?? 'Sin título',
      tipoAlerta: "Alarma Pública", 
      sector: json['ubicacion'] ?? 'Sector no disponible',
      distancia: 0.0,
      fecha: json['fecha'] != null ? DateTime.parse(json['fecha']) : DateTime.now(),
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      estado: json['estado'] ?? 'emitida',
    );
  }

  AlertaModel copyWith({
    bool? leida,
    String? estado,
  }) {
    return AlertaModel(
      id: id,
      tipoEmergencia: tipoEmergencia,
      tipoAlerta: tipoAlerta,
      sector: sector,
      distancia: distancia,
      fecha: fecha,
      lat: lat,
      lng: lng,
      leida: leida ?? this.leida,
      estado: estado ?? this.estado,
    );
  }
}