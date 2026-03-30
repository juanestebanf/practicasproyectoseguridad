class OperatorModel {
  final String id;
  final String nombre;
  final String telefono;
  bool activo;
  final String? rol;

  OperatorModel({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.activo,
    this.rol,
  });
}