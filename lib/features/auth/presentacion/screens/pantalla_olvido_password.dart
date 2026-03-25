import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/core/services/auth_service.dart';
import 'package:app_seguridadmx/features/auth/presentacion/widgets/custom_snackbar.dart';

class PantallaOlvidoPassword extends StatefulWidget {
  const PantallaOlvidoPassword({super.key});

  @override
  State<PantallaOlvidoPassword> createState() => _PantallaOlvidoPasswordState();
}

class _PantallaOlvidoPasswordState extends State<PantallaOlvidoPassword> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  void _enviarCodigo() async {
    if (_emailController.text.trim().isEmpty) {
      CustomSnackbar.showError(context, 'Por favor, ingrese su correo electrónico');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final message = await AuthService.forgotPassword(_emailController.text.trim());
      if (mounted) {
        CustomSnackbar.showSuccess(context, message);
        Navigator.pushNamed(context, '/restablecer-password', arguments: _emailController.text.trim());
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
            Text(
              'Recuperar\nContraseña',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Ingrese su correo electrónico y le enviaremos un código de 6 dígitos para restablecer su acceso.',
              style: TextStyle(color: ColoresApp.textoSecundario, fontSize: 16),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Correo Electrónico',
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _enviarCodigo,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Enviar Código'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
