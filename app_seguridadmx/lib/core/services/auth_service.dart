class AuthService {

  static const _adminEmail = "admin@gmail.com";
  static const _adminPass  = "Admin123";

  static const _vigilanteEmail = "vigilante@gmail.com";
  static const _vigilantePass  = "Vigilante123";

  static Future<String?> login(String email, String password) async {

    await Future.delayed(const Duration(milliseconds: 500));

    if (email == _adminEmail && password == _adminPass) {
      return "admin";
    }

    if (email == _vigilanteEmail && password == _vigilantePass) {
      return "vigilante";
    }

    // Si no coincide con ninguno
    return "user"; 
  }
}