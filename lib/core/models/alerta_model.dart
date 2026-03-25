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
      id: json['id'],
      tipoEmergencia: json['titulo'],
      tipoAlerta: "Alarma Pública", // Default or map from backend if needed
      sector: json['ubicacion'],
      distancia: 0.0, // Calculate client-side if needed
      fecha: DateTime.parse(json['fecha']),
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      estado: json['estado'],
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