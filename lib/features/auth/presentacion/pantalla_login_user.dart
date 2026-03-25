import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/features/auth/presentacion/widgets/camptext_personalizado.dart';
import 'package:app_seguridadmx/features/auth/presentacion/widgets/custom_snackbar.dart';
import 'package:app_seguridadmx/rutas/rutas_app.dart';
import 'package:app_seguridadmx/core/services/auth_service.dart';

class LoginUsuarioScreen extends StatefulWidget {
  const LoginUsuarioScreen({super.key});

  @override
  State<LoginUsuarioScreen> createState() => _LoginUsuarioScreenState();
}

class _LoginUsuarioScreenState extends State<LoginUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();

  final _identificacionController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _identificacionController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  /// 🔹 LOGIN
  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _identificacionController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      final rol = await AuthService.login(email, password);

      if (!mounted) return;

      switch (rol) {
        case "admin":
          Navigator.pushReplacementNamed(context, AppRutas.homeAdmin);
          break;
        case "vigilante":
        case "operador":
          Navigator.pushReplacementNamed(context, AppRutas.homeVigilante);
          break;
        case "user":
          Navigator.pushReplacementNamed(context, AppRutas.homeUsuario);
          break;
        default:
          CustomSnackbar.showError(context, "Rol no reconocido");
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
              color: ColoresApp.textoBlanco, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Acceso Seguro',
          style: TextStyle(
            color: ColoresApp.textoBlanco,
            fontWeight: FontWeight.w600,
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
              const SizedBox(height: 40),

              /// Logo
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: ColoresApp.rojoPrincipal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.admin_panel_settings,
                  size: 70,
                  color: ColoresApp.rojoPrincipal,
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Emergencias Loja',
                style: TextStyle(
                  color: ColoresApp.textoBlanco,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Plataforma Institucional de Respuesta',
                style: TextStyle(
                  color: ColoresApp.textoSecundario,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 48),

              /// Campo identificación
              CampoTextoPersonalizado(
                label: 'CÉDULA O CORREO',
                hint: 'Ingrese su identificación',
                icono: Icons.person_outline,
                controller: _identificacionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese su identificación';
                  }
                  return null;
                },
              ),

              /// Campo contraseña
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
                  if (value == null || value.isEmpty) {
                    return 'Ingrese su contraseña';
                  }
                  if (value.length < 6) {
                    return 'La contraseña debe tener mínimo 6 caracteres';
                  }
                  return null;
                },
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRutas.olvidoPassword),
                  child: const Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                      color: ColoresApp.textoSecundario,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// Botón login
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _iniciarSesion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColoresApp.rojoPrincipal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                      )
                    : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.login, size: 20),
                    ],
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