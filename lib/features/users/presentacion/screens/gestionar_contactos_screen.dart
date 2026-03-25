import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/core/storage/contactos_storage_service.dart';
import 'package:app_seguridadmx/core/services/contactos_phone_service.dart';

class GestionarContactosScreen extends StatefulWidget {
  const GestionarContactosScreen({super.key});

  @override
  State<GestionarContactosScreen> createState() =>
      _GestionarContactosScreenState();
}

class _GestionarContactosScreenState extends State<GestionarContactosScreen> {
  static const Color accentRed = ColoresApp.rojoPrincipal;
  static const Color backgroundDark = ColoresApp.fondoOscuro;
  static const Color cardDark = ColoresApp.fondoInput;

  // ─────────────────────────────────────────────────────────
  // Importar desde la agenda del celular
  // ─────────────────────────────────────────────────────────
  Future<void> _importarDesdeAgenda() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: accentRed),
      ),
    );

    final contactosTelefono =
        await ContactosPhoneService.obtenerContactosTelefono();

    if (!mounted) return;
    Navigator.pop(context); // cerrar loader

    if (contactosTelefono.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontraron contactos o se denegó el permiso.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Selección multiple
    final seleccionados = <int>{};

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: backgroundDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.85,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (_, scrollController) {
              return Column(
                children: [
                  // handle
                  Container(
                    margin: const EdgeInsets.all(14),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const Text(
                    'Selecciona contactos',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${seleccionados.length} seleccionados',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const Divider(color: Colors.white12, height: 20),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: contactosTelefono.length,
                      itemBuilder: (_, i) {
                        final c = contactosTelefono[i];
                        final isSelected = seleccionados.contains(i);
                        return ListTile(
                          onTap: () {
                            setModalState(() {
                              if (isSelected) {
                                seleccionados.remove(i);
                              } else {
                                seleccionados.add(i);
                              }
                            });
                          },
                          leading: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? accentRed
                                  : accentRed.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                c['iniciales'] ?? '?',
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : accentRed,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          title: Text(c['nombre'] ?? '',
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text(c['telefono'] ?? '',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle,
                                  color: accentRed)
                              : const Icon(Icons.radio_button_unchecked,
                                  color: Colors.white24),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentRed,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        icon: const Icon(Icons.save_alt, color: Colors.white),
                        label: Text(
                          'Guardar ${seleccionados.length} contacto(s)',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        onPressed: seleccionados.isEmpty
                            ? null
                            : () => Navigator.pop(ctx),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );

    if (seleccionados.isEmpty) return;

    // Guardar en backend
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: CircularProgressIndicator(color: accentRed)),
    );

    try {
      final paraGuardar = seleccionados
          .map((i) => contactosTelefono[i])
          .toList();
      await ContactosStorageService.guardarContactos(paraGuardar);
      if (!mounted) return;
      Navigator.pop(context); // cerrar loader
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '✅ ${paraGuardar.length} contacto(s) guardados como SOS'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // ─────────────────────────────────────────────────────────
  // Modal editar/crear manual
  // ─────────────────────────────────────────────────────────
  void _mostrarModalAgregarContacto(
      [Map<String, dynamic>? contactoEditar]) {
    final nombreController =
        TextEditingController(text: contactoEditar?['nombre'] ?? '');
    final telefonoController =
        TextEditingController(text: contactoEditar?['telefono'] ?? '');
    final formKey = GlobalKey<FormState>();
    final esEdicion = contactoEditar != null;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: cardDark,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Column(children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentRed.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(esEdicion ? Icons.edit : Icons.person_add_alt_1,
                color: accentRed, size: 30),
          ),
          const SizedBox(height: 15),
          Text(
            esEdicion ? 'Editar Contacto SOS' : 'Nuevo Contacto SOS',
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ]),
        content: Form(
          key: formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            _buildTextField(
              controller: nombreController,
              label: 'Nombre Completo',
              icon: Icons.person_outline,
              validator: (v) => v!.isEmpty ? 'Ingresa un nombre' : null,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              controller: telefonoController,
              label: 'Número de Teléfono',
              icon: Icons.phone_android_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) =>
                  v!.length < 7 ? 'Número no válido' : null,
            ),
          ]),
        ),
        actionsPadding: const EdgeInsets.all(15),
        actions: [
          Row(children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar',
                    style: TextStyle(color: Colors.grey)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentRed,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final nombre = nombreController.text.trim();
                    final partes = nombre.split(' ');
                    final iniciales = partes.length >= 2
                        ? '${partes[0][0]}${partes[1][0]}'.toUpperCase()
                        : nombre
                            .substring(
                                0, nombre.length >= 2 ? 2 : 1)
                            .toUpperCase();

                    final nuevoContacto = {
                      'nombre': nombre,
                      'telefono': telefonoController.text.trim(),
                      'iniciales': iniciales,
                    };

                    try {
                      if (esEdicion && contactoEditar?['id'] != null) {
                        await ContactosStorageService.actualizarContacto(
                            contactoEditar!['id'].toString(),
                            nuevoContacto);
                      } else {
                        await ContactosStorageService.agregarContacto(
                            nuevoContacto);
                      }
                      if (mounted) {
                        setState(() {});
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())));
                    }
                  }
                },
                child: Text(
                  esEdicion ? 'Actualizar' : 'Guardar',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ]),
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
        prefixIcon: Icon(icon, color: accentRed, size: 20),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: backgroundDark,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentRed),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark,
        elevation: 0,
        title: const Text(
          'Contactos SOS',
          style: TextStyle(
              color: ColoresApp.textoBlanco, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: ColoresApp.textoBlanco),
        actions: [
          IconButton(
            tooltip: 'Importar desde agenda',
            icon: const Icon(Icons.contacts_rounded, color: accentRed),
            onPressed: _importarDesdeAgenda,
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ContactosStorageService.obtenerContactos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: accentRed));
          }

          final contactos = snapshot.data ?? [];

          if (contactos.isEmpty) return _buildEmptyState();

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: contactos.length,
            itemBuilder: (_, index) {
              final contacto =
                  Map<String, dynamic>.from(contactos[index]);
              contacto['indice'] = index;

              return GestureDetector(
                onTap: () => _mostrarModalAgregarContacto(contacto),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: cardDark,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.05)),
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
                          fontWeight: FontWeight.w600),
                    ),
                    subtitle: Row(children: [
                      const Icon(Icons.phone,
                          color: Colors.grey, size: 14),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          contacto['telefono'] ?? '',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline_rounded,
                          color: Colors.redAccent),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: cardDark,
                            title: const Text('Eliminar Contacto',
                                style: TextStyle(color: Colors.white)),
                            content: const Text(
                                '¿Estás seguro de eliminar este contacto?',
                                style: TextStyle(color: Colors.white70)),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                child: const Text('Cancelar',
                                    style:
                                        TextStyle(color: Colors.grey)),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent),
                                onPressed: () =>
                                    Navigator.pop(context, true),
                                child: const Text('Eliminar',
                                    style:
                                        TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true &&
                            contacto['id'] != null) {
                          try {
                            await ContactosStorageService
                                .eliminarContacto(
                                    contacto['id'].toString());
                            setState(() {});
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Error al eliminar: $e')));
                          }
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: accentRed,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text('Agregar',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () => _mostrarModalAgregarContacto(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.contact_phone_outlined,
              size: 80, color: accentRed.withOpacity(0.3)),
          const SizedBox(height: 20),
          const Text('No tienes contactos de emergencia',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Toca el ícono de contactos (arriba) para importar desde tu teléfono, o el botón "Agregar" para crear uno manual.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: accentRed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.contacts_rounded, color: Colors.white),
            label: const Text('Importar del Teléfono',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            onPressed: _importarDesdeAgenda,
          ),
        ],
      ),
    );
  }
}
