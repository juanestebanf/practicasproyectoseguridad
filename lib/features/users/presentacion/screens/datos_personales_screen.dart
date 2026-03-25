import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';

class DatosPersonalesScreen extends StatelessWidget {
  const DatosPersonalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundDark = Color(0xFF0D0D0D);
    const cardColor = Color(0xFF1A1A1A);
    const accentRed = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
      backgroundColor: backgroundDark,
      elevation: 0,
      // Cambia esta línea:
      title: const Text(
        "Datos Personales", 
        style: TextStyle(
          color: ColoresApp.textoBlanco, // <--- Uso de tu archivo de colores
          fontWeight: FontWeight.bold
        )
      ),
      iconTheme: const IconThemeData(color: ColoresApp.textoBlanco), // Para que la flecha de volver también sea blanca
    ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("INFORMACIÓN BÁSICA"),
            _buildCustomTextField("Nombre completo", Icons.person_outline, "Juan Pérez"),
            _buildCustomTextField("Cédula / ID", Icons.badge_outlined, "1104567890", enabled: false),
            _buildCustomTextField("Correo electrónico", Icons.email_outlined, "juan.perez@email.com"),
            _buildCustomTextField("Teléfono", Icons.phone_android_outlined, "+593 99 999 9999"),
            
            const SizedBox(height: 25),
            _sectionTitle("INFORMACIÓN MÉDICA (EMERGENCIAS)"),
            _buildCustomTextField("Tipo de Sangre", Icons.bloodtype_outlined, "O+"),
            _buildCustomTextField("Alergias / Notas", Icons.medical_services_outlined, "Ninguna conocida"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: accentRed,
        onPressed: () {},
        icon: const Icon(Icons.save),
        label: const Text("Guardar Cambios"),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 10, top: 10),
      child: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
    );
  }

  Widget _buildCustomTextField(String label, IconData icon, String initialValue, {bool enabled = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        initialValue: initialValue,
        enabled: enabled,
        style: TextStyle(color: enabled ? Colors.white : Colors.grey),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: const Color(0xFFE53935)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }
}