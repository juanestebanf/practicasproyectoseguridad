import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/core/services/auth_service.dart';
import 'package:app_seguridadmx/features/auth/presentacion/widgets/custom_snackbar.dart';

class PantallaRestablecerPassword extends StatefulWidget {
  const PantallaRestablecerPassword({super.key});

  @override
  State<PantallaRestablecerPassword> createState() => _PantallaRestablecerPasswordState();
}

class _PantallaRestablecerPasswordState extends State<PantallaRestablecerPassword> {
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _restablecer() async {
    if (_codeController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      CustomSnackbar.showError(context, 'Todos los campos son obligatorios');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final message = await AuthService.resetPassword(
        _codeController.text.trim(),
        _passwordController.text.trim(),
      );
      if (mounted) {
        CustomSnackbar.showSuccess(context, message);
        Navigator.pushNamedAndRemoveUntil(context, '/login-user', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(context, e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Nueva\nContraseña',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ingrese el código de 6 dígitos que enviamos a su consola y defina su nueva contraseña.',
              style: TextStyle(color: ColoresApp.textoSecundario, fontSize: 16),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Código de 6 dígitos',
                prefixIcon: Icon(Icons.lock_clock_outlined),
                counterText: "",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nueva Contraseña',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white54,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _restablecer,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Restablecer Contraseña'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
