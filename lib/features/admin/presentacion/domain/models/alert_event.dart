enum AlertEventType {
  creada,
  asignada,
  cambioEstado,
  reporteSubido,
}

class AlertEvent {
  final AlertEventType tipo;
  final DateTime fecha;
  final String descripcion;

  AlertEvent({
    required this.tipo,
    required this.fecha,
    required this.descripcion,
  });
}