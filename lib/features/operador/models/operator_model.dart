class OperatorModel {
  final String id;
  final String nombre;
  final String rol;

  final OperatorStats estadisticas;

  OperatorModel({
    required this.id,
    required this.nombre,
    required this.rol,
    required this.estadisticas,
  });

  OperatorModel copyWith({
    String? nombre,
    String? rol,
    OperatorStats? estadisticas,
  }) {
    return OperatorModel(
      id: id,
      nombre: nombre ?? this.nombre,
      rol: rol ?? this.rol,
      estadisticas: estadisticas ?? this.estadisticas,
    );
  }
}

class OperatorStats {
  final int alertasAtendidasHoy;

  final double eficiencia;

  final String tiempoPromedioRespuesta;

  OperatorStats({
    required this.alertasAtendidasHoy,
    required this.eficiencia,
    required this.tiempoPromedioRespuesta,
  });

  OperatorStats copyWith({
    int? alertasAtendidasHoy,
    double? eficiencia,
    String? tiempoPromedioRespuesta,
  }) {
    return OperatorStats(
      alertasAtendidasHoy:
          alertasAtendidasHoy ?? this.alertasAtendidasHoy,
      eficiencia: eficiencia ?? this.eficiencia,
      tiempoPromedioRespuesta:
          tiempoPromedioRespuesta ?? this.tiempoPromedioRespuesta,
    );
  }
}