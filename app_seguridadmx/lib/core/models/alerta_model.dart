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