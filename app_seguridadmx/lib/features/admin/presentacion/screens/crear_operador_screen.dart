import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:app_seguridadmx/features/admin/presentacion/data/admin_fake_repository.dart';
import 'package:app_seguridadmx/features/admin/presentacion/domain/models/operator_model.dart';

class CrearOperadorScreen extends StatefulWidget {
  const CrearOperadorScreen({super.key});

  @override
  State<CrearOperadorScreen> createState() => _CrearOperadorScreenState();
}

class _CrearOperadorScreenState extends State<CrearOperadorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  String selectedRol = "operador";
  final AdminFakeRepository repository = AdminFakeRepository();

  // Método auxiliar para mantener el estilo de los inputs uniforme
  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFFE53935).withOpacity(0.7), size: 20),
      filled: true,
      fillColor: const Color(0xFF1E1414),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.white10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFE53935)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const backgroundDark = Color(0xFF0D0D0D);
    const accentRed = Color(0xFFE53935);

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
      body: SingleChildScrollView( // Añadido para evitar overflow con el teclado
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Datos Personales",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.2),
                ),
                const SizedBox(height: 15),

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
                    if (!value.startsWith('0')) return "Debe empezar con 0";
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: selectedRol,
                  dropdownColor: const Color(0xFF1E1414),
                  style: const TextStyle(color: Colors.white),
                  decoration: _buildInputDecoration("Rol de acceso", Icons.admin_panel_settings_outlined),
                  items: const [
                    DropdownMenuItem(value: "operador", child: Text("Operador")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedRol = value!;
                    });
                  },
                ),

                const SizedBox(height: 50),

                SizedBox(
                  width: double.infinity,
                  height: 55, // Botón más alto y ergonómico
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentRed,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 5,
                      shadowColor: accentRed.withOpacity(0.4),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final newOperator = OperatorModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          nombre: nombreController.text,
                          telefono: telefonoController.text,
                          activo: true,
                        );

                        repository.addOperator(newOperator);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      "GUARDAR OPERADOR", 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}