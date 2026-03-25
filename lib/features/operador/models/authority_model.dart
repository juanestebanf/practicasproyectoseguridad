class AuthorityModel {
  final String id;
  final String nombre;
  final String tipo;

  AuthorityModel({
    required this.id,
    required this.nombre,
    required this.tipo,
  });

  factory AuthorityModel.fromJson(Map<String, dynamic> json) {
    return AuthorityModel(
      id: json['id'],
      nombre: json['nombre'],
      tipo: json['tipo'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'tipo': tipo,
  };
}
