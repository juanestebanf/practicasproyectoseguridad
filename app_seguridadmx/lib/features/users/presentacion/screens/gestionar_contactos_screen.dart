import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/core/storage/contactos_storage_service.dart';

class GestionarContactosScreen extends StatefulWidget {
  const GestionarContactosScreen({super.key});

  @override
  State<GestionarContactosScreen> createState() =>
      _GestionarContactosScreenState();
}

class _GestionarContactosScreenState extends State<GestionarContactosScreen> {

  void _mostrarModalAgregarContacto([Map<String, dynamic>? contactoEditar]) {
    final nombreController = TextEditingController(
        text: contactoEditar?['nombre'] ?? '');
    final telefonoController = TextEditingController(
        text: contactoEditar?['telefono'] ?? '');
    final formKey = GlobalKey<FormState>();
    final esEdicion = contactoEditar != null;
    final indiceEditar = esEdicion 
        ? (contactoEditar?['indice'] ?? -1) 
        : -1;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE53935).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                esEdicion ? Icons.edit : Icons.person_add_alt_1, 
                color: const Color(0xFFE53935), 
                size: 30
              ),
            ),
            const SizedBox(height: 15),
            Text(
              esEdicion ? "Editar Contacto SOS" : "Nuevo Contacto SOS",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, 
                  fontSize: 18, 
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(
                controller: nombreController,
                label: "Nombre Completo",
                icon: Icons.person_outline,
                validator: (v) => v!.isEmpty ? "Ingresa un nombre" : null,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: telefonoController,
                label: "Número de Teléfono",
                icon: Icons.phone_android_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) => v!.length < 10 ? "Número no válido" : null,
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.all(15),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar", 
                      style: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final contactos = await ContactosStorageService.obtenerContactos();
                      final nombre = nombreController.text.trim();
                      
                      // Lógica de iniciales mejorada
                      List<String> partes = nombre.split(" ");
                      String iniciales = partes.length >= 2 
                          ? (partes[0][0] + partes[1][0]).toUpperCase()
                          : nombre.substring(0, (nombre.length >= 2 ? 2 : 1)).toUpperCase();

                      final nuevoContacto = {
                        "nombre": nombre,
                        "telefono": telefonoController.text.trim(),
                        "iniciales": iniciales,
                        "seleccionado": contactoEditar?['seleccionado'] ?? true
                      };

                      if (esEdicion && indiceEditar >= 0) {
                        // ✅ MODO EDICIÓN: reemplaza el contacto
                        contactos[indiceEditar] = nuevoContacto;
                      } else {
                        // ✅ MODO NUEVO: agrega contacto
                        contactos.add(nuevoContacto);
                      }

                      await ContactosStorageService.guardarContactos(contactos);
                      setState(() {});
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    esEdicion ? "Actualizar" : "Guardar", 
                    style: const TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.bold)
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFFE53935), size: 20),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFF0D0D0D),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE53935)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const accentRed = Color(0xFFE53935);
    const backgroundDark = Color(0xFF0D0D0D);

    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark,
        elevation: 0,
        title: const Text(
          "Contactos SOS",
          style: TextStyle(
              color: ColoresApp.textoBlanco,
              fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: ColoresApp.textoBlanco),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ContactosStorageService.obtenerContactos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: accentRed));
          }

          final contactos = snapshot.data ?? [];

          if (contactos.isEmpty) {
            return _buildEmptyState(accentRed);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: contactos.length,
            itemBuilder: (_, index) {
              final contacto = Map<String, dynamic>.from(contactos[index]);
              contacto['indice'] = index; // ✅ Para saber cuál editar

              return GestureDetector(
                /// ✅ TAP PARA EDITAR
                onTap: () => _mostrarModalAgregarContacto(contacto),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 5),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE53935), Color(0xFFB71C1C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          contacto['iniciales'] ?? '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      contacto['nombre'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.grey, size: 14),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            contacto['telefono'] ?? '',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline_rounded,
                          color: Colors.redAccent),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: const Color(0xFF1A1A1A),
                            title: const Text("Eliminar Contacto",
                                style: TextStyle(color: Colors.white)),
                            content: const Text(
                                "¿Estás seguro de eliminar este contacto?",
                                style: TextStyle(color: Colors.white70)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancelar",
                                    style: TextStyle(color: Colors.grey)),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent),
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Eliminar",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          contactos.removeAt(index);
                          await ContactosStorageService.guardarContactos(contactos);
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentRed,
        child: const Icon(Icons.person_add, color: Colors.white),
        onPressed: () => _mostrarModalAgregarContacto(), // ✅ Sin parámetro = nuevo
      ),
    );
  }

  Widget _buildEmptyState(Color accentRed) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.contact_phone_outlined,
            size: 80,
            color: accentRed.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          const Text(
            "No tienes contactos de emergencia",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Text(
              "Añade contactos de confianza para que reciban tu ubicación en caso de alerta.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
