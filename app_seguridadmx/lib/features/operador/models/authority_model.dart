class AuthorityModel {
  final String id;
  final String nombre; // Ej: "Policía Nacional", "Bomberos", "Ambulancia"
  final String tipo; // Ej: "POLICIA", "BOMBEROS", "MEDICO"

  AuthorityModel({
    required this.id,
    required this.nombre,
    required this.tipo,
  });
}
