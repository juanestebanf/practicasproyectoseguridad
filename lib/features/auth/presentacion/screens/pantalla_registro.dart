import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import '../widgets/camptext_personalizado.dart';
import 'package:app_seguridadmx/features/auth/presentacion/widgets/custom_snackbar.dart';
import 'package:app_seguridadmx/core/services/auth_service.dart';

class RegistroUsuarioScreen extends StatefulWidget {
  const RegistroUsuarioScreen({super.key});

  @override
  State<RegistroUsuarioScreen> createState() => _RegistroUsuarioScreenState();
}

class _RegistroUsuarioScreenState extends State<RegistroUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _aceptaTerminos = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _cedulaController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_aceptaTerminos) {
      CustomSnackbar.showError(context, "Debe aceptar los términos y condiciones");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await AuthService.register(
        nombre: _nombreController.text.trim(),
        cedula: _cedulaController.text.trim(),
        email: _correoController.text.trim(),
        telefono: _telefonoController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        CustomSnackbar.showSuccess(context, "Registro exitoso. Ahora puede iniciar sesión.");
        Navigator.pop(context);
      } else {
        CustomSnackbar.showError(context, "No se pudo completar el registro.");
      }
    } catch (e) {
      if (!mounted) return;
      CustomSnackbar.showError(context, e.toString().replaceAll("Exception: ", ""));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondoOscuro,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: ColoresApp.textoBlanco),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Registro de Usuario',
          style: TextStyle(
            color: ColoresApp.textoBlanco,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 24),

              CampoTextoPersonalizado(
                label: 'NOMBRE COMPLETO',
                hint: 'Ej: Juan Pérez',
                icono: Icons.person_outline,
                controller: _nombreController,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese su nombre' : null,
              ),

              CampoTextoPersonalizado(
                label: 'CÉDULA',
                hint: '110XXXXXXXXX',
                icono: Icons.badge_outlined,
                controller: _cedulaController,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingrese su cédula';
                  if (value.trim().length != 11) return 'La cédula debe tener 11 dígitos';
                  return null;
                },
              ),

              CampoTextoPersonalizado(
                label: 'CORREO',
                hint: 'correo@ejemplo.com',
                icono: Icons.email_outlined,
                controller: _correoController,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingrese su correo';
                  return null;
                },
              ),

              CampoTextoPersonalizado(
                label: 'TELÉFONO',
                hint: '09XXXXXXXX',
                icono: Icons.phone_android_outlined,
                controller: _telefonoController,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese su teléfono' : null,
              ),

              CampoTextoPersonalizado(
                label: 'CONTRASEÑA',
                hint: '********',
                icono: Icons.lock_outline,
                controller: _passwordController,
                esPassword: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingrese una contraseña';
                  if (value.length < 6) return 'Mínimo 6 caracteres requeridos';
                  if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) return 'Debe contener al menos una mayúscula';
                  if (!RegExp(r'(?=.*\d)').hasMatch(value)) return 'Debe contener al menos un número';
                  return null;
                },
              ),

              CampoTextoPersonalizado(
                label: 'CONFIRMAR CONTRASEÑA',
                hint: '********',
                icono: Icons.lock_outline,
                controller: _confirmPasswordController,
                esPassword: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword =
                          !_obscureConfirmPassword;
                    });
                  },
                ),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),

              Row(
                children: [
                  Checkbox(
                    value: _aceptaTerminos,
                    onChanged: (val) =>
                        setState(() => _aceptaTerminos = val!),
                    activeColor: ColoresApp.rojoPrincipal,
                  ),
                  const Expanded(
                    child: Text(
                      'Acepto los términos y condiciones.',
                      style: TextStyle(
                          color: ColoresApp.textoSecundario),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _registrar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColoresApp.rojoPrincipal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading 
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                      ) 
                    : const Text(
                    'Crear Cuenta',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}