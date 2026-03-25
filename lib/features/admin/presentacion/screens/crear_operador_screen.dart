import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/core/services/auth_service.dart';
import 'package:app_seguridadmx/features/auth/presentacion/widgets/custom_snackbar.dart';

class CrearOperadorScreen extends StatefulWidget {
  const CrearOperadorScreen({super.key});

  @override
  State<CrearOperadorScreen> createState() => _CrearOperadorScreenState();
}

class _CrearOperadorScreenState extends State<CrearOperadorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cedulaController = TextEditingController();
  String selectedRol = "operador";
  bool _isLoading = false;

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: ColoresApp.textoSecundario, fontSize: 14),
      prefixIcon: Icon(icon, color: ColoresApp.rojoPrincipal.withOpacity(0.7), size: 20),
      filled: true,
      fillColor: ColoresApp.fondoInput,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: ColoresApp.rojoPrincipal),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: ColoresApp.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: ColoresApp.error, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const backgroundDark = ColoresApp.fondoOscuro;
    const accentRed = ColoresApp.rojoPrincipal;

    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Nuevo Operador", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "DATOS DE REGISTRO",
                  style: TextStyle(
                    color: ColoresApp.textoSecundario, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 11, 
                    letterSpacing: 2.0
                  ),
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: nombreController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _buildInputDecoration("Nombre Completo", Icons.person_outline),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Ingresa el nombre" : null,
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: telefonoController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: _buildInputDecoration("Teléfono", Icons.phone_android_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Ingresa el teléfono";
                    if (value.length != 10) return "Debe tener 10 dígitos";
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: cedulaController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: _buildInputDecoration("Cédula", Icons.badge_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Ingresa la cédula";
                    if (value.length != 10) return "Debe tener 10 dígitos";
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: _buildInputDecoration("Correo Institucional", Icons.email_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Obligatorio";
                    if (!value.contains('@')) return "Correo inválido";
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: passwordController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: _buildInputDecoration("Contraseña Temporal", Icons.lock_outline),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Obligatorio";
                    if (value.length < 6) return "Mínimo 6 caracteres";
                    return null;
                  },
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentRed,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 8,
                      shadowColor: accentRed.withOpacity(0.5),
                    ),
                    onPressed: _isLoading ? null : () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _isLoading = true);
                        try {
                          final exito = await AuthService.register(
                            nombre: nombreController.text,
                            cedula: cedulaController.text,
                            email: emailController.text,
                            telefono: telefonoController.text,
                            password: passwordController.text,
                            rol: "operador",
                          );
                          if (exito && context.mounted) {
                            CustomSnackbar.showSuccess(context, "Operador dado de alta exitosamente");
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          if (context.mounted) CustomSnackbar.showError(context, "Error al crear: $e");
                        } finally {
                          if (mounted) setState(() => _isLoading = false);
                        }
                      }
                    },
                    child: _isLoading 
                      ? const SizedBox(
                          height: 20, 
                          width: 20, 
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        )
                      : const Text(
                          "CREAR OPERADOR", 
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 1.1)
                        ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}