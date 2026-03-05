import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';

class SeguridadCuentaScreen extends StatelessWidget {
  const SeguridadCuentaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundDark = Color(0xFF0D0D0D);
    const accentRed = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
      backgroundColor: backgroundDark,
      elevation: 0,
      title: const Text(
        "Seguridad de Cuenta", 
        style: TextStyle(
          color: ColoresApp.textoBlanco, 
          fontWeight: FontWeight.bold
        )
      ),
      iconTheme: const IconThemeData(color: ColoresApp.textoBlanco),
    ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSecurityTile("Huella Dactilar / FaceID", "Usar biometría para emitir alertas rápidas", true),
          const SizedBox(height: 25),
          const Text("CAMBIAR CONTRASEÑA", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          _buildPasswordField("Contraseña actual"),
          _buildPasswordField("Nueva contraseña"),
          _buildPasswordField("Confirmar nueva contraseña"),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: accentRed,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: () {},
            child: const Text("Actualizar Credenciales", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTile(String title, String sub, bool val) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(15)),
      child: SwitchListTile(
        activeColor: const Color(0xFFE53935),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        value: val,
        onChanged: (v) {},
      ),
    );
  }

  Widget _buildPasswordField(String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(15)),
      child: TextField(
        obscureText: true,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFE53935)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
      ),
    );
  }
}