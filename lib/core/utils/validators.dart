/// Validators for Ecuadorian identity documents and form fields.

/// Validates an Ecuadorian Cédula (10 digits) using the Modulo 10 algorithm.
/// Returns null if valid, or an error message if invalid.
String? validarCedula(String? value) {
  if (value == null || value.isEmpty) {
    return 'Ingrese su cédula';
  }

  final cedula = value.trim();

  // Cédula must be exactly 10 digits
  if (cedula.length != 10) {
    return 'La cédula debe tener 10 dígitos';
  }

  // Must contain only digits
  if (!RegExp(r'^\d+$').hasMatch(cedula)) {
    return 'La cédula solo debe contener números';
  }

  // Modulo 10 validation algorithm for Ecuadorian Cédula
  // Coefficients = 2, 1, 2, 1, 2, 1, 2, 1, 2
  final coeficientes = [2, 1, 2, 1, 2, 1, 2, 1, 2];
  int suma = 0;

  for (int i = 0; i < 9; i++) {
    int digito = int.parse(cedula[i]);
    int producto = digito * coeficientes[i];
    
    // If product is greater than 9, sum the digits (e.g., 12 -> 1+2=3)
    if (producto > 9) {
      producto = (producto ~/ 10) + (producto % 10);
    }
    suma += producto;
  }

  // Calculate the verifier digit
  // Residue of sum / 10 is the verifier (as described by the user)
  // Example: 25 / 10 -> Residue 5.
  // Standard rule is actually 10 - (suma % 10), but user specified residue.
  // However, "cuando el residuo es 0 el digito verificador es 0" fits both.
  int residuo = suma % 10;
  int digitoVerificador = (residuo == 0) ? 0 : (10 - residuo);

  // The last digit of the cédula should match the calculated verifier digit
  int ultimoDigito = int.parse(cedula[9]);

  if (digitoVerificador != ultimoDigito) {
    return 'Cédula inválida (algoritmo Módulo 10)';
  }

  return null;
}

/// Validates an Ecuadorian RUC (Registro Único de Contribuyentes).
/// - 13 digits
/// - Third digit must be 6 (public) or 9 (private)
/// - Last 3 digits must be 001
/// Returns null if valid, or an error message if invalid.
String? validarRuc(String value) {
  if (value == null || value.isEmpty) {
    return 'Ingrese su RUC';
  }

  final ruc = value.trim();

  // RUC must be exactly 13 digits
  if (ruc.length != 13) {
    return 'El RUC debe tener 13 dígitos';
  }

  // Must contain only digits
  if (!RegExp(r'^\d+$').hasMatch(ruc)) {
    return 'El RUC solo debe contener números';
  }

  // Third digit (index 2) must be 6 (public institution) or 9 (private institution)
  int tercerDigito = int.parse(ruc[2]);
  if (tercerDigito != 6 && tercerDigito != 9) {
    return 'El tercer dígito del RUC debe ser 6 o 9 (Privada/Pública)';
  }

  // Last 3 digits must be 001
  String ultimosTres = ruc.substring(ruc.length - 3);
  if (ultimosTres != '001') {
    return 'Los últimos 3 dígitos del RUC deben ser 001';
  }

  // Also validate the first 10 digits as a valid Cedula structure
  // (Optional, but good for consistency)
  // return validarCedula(ruc.substring(0, 10));
  
  return null;
}

/// Combined validator for Cédula or RUC.
/// Returns null if valid, or an error message if invalid.
String? validarCedulaORuc(String? value) {
  if (value == null || value.isEmpty) {
    return 'Ingrese su cédula o RUC';
  }

  final documento = value.trim();

  if (documento.length == 13) {
    return validarRuc(documento);
  } else if (documento.length == 10) {
    return validarCedula(documento);
  } else {
    return 'Documento debe tener 10 (Cédula) o 13 (RUC) dígitos';
  }
}

/// Validates password strength:
/// - Minimum 6 characters
/// - At least one uppercase letter
/// - At least one lowercase letter
/// - At least one number
/// Returns null if valid, or an error message if invalid.
String? validarPassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Ingrese una contraseña';
  }

  if (value.length < 6) {
    return 'Mínimo 6 caracteres';
  }

  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return 'Debe incluir al menos una MAYÚSCULA';
  }

  if (!RegExp(r'[a-z]').hasMatch(value)) {
    return 'Debe incluir al menos una minúscula';
  }

  if (!RegExp(r'\d').hasMatch(value)) {
    return 'Debe incluir al menos un número';
  }

  return null;
}

/// Validates email format.
/// Returns null if valid, or an error message if invalid.
String? validarEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Ingrese su correo';
  }

  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  if (!emailRegex.hasMatch(value)) {
    return 'Ingrese un correo electrónico válido';
  }

  return null;
}

/// Validates that a field is not empty.
/// Returns null if valid, or an error message if invalid.
String? validarNoVacio(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) {
    return 'Ingrese $fieldName';
  }
  return null;
}

/// Validates Ecuadorian phone number (10 digits, starts with 09).
/// Returns null if valid, or an error message if invalid.
String? validarTelefono(String? value) {
  if (value == null || value.isEmpty) {
    return 'Ingrese su teléfono';
  }

  final telefono = value.trim();

  if (!RegExp(r'^09\d{8}$').hasMatch(telefono)) {
    return 'El teléfono debe tener 10 dígitos y empezar con 09';
  }

  return null;
}
