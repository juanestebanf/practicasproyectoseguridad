import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/features/users/presentacion/widgets/usuario_bottom_nav_widget.dart';
import 'package:app_seguridadmx/core/services/auth_service.dart';
import 'package:app_seguridadmx/rutas/rutas_app.dart';
import 'package:app_seguridadmx/core/services/user_service.dart';
import 'package:app_seguridadmx/app/widgets/avatar_selection_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

class PerfilUsuarioScreen extends StatefulWidget {
  const PerfilUsuarioScreen({super.key});

  @override
  State<PerfilUsuarioScreen> createState() => _PerfilUsuarioScreenState();
}

class _PerfilUsuarioScreenState extends State<PerfilUsuarioScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final data = await UserService.getProfile();
      if (mounted) {
        setState(() {
          _userData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar perfil: $e')),
        );
      }
    }
  }

  Future<void> _cambiarFoto() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColoresApp.fondoInput,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera, color: Colors.white),
            title: const Text("Tomar Foto", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: Colors.white),
            title: const Text("Seleccionar de Galería", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.face, color: Colors.white),
            title: const Text("Seleccionar Avatar", style: TextStyle(color: Colors.white)),
            onTap: () async {
              Navigator.pop(context);
              final result = await showDialog<String>(
                context: context,
                builder: (context) => const AvatarSelectionDialog(),
              );
              if (result != null) {
                _updatePhoto(result);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source, maxWidth: 300, maxHeight: 300, imageQuality: 70);
    if (image != null) {
      final bytes = await File(image.path).readAsBytes();
      final base64Image = "data:image/png;base64,${base64Encode(bytes)}";
      _updatePhoto(base64Image);
    }
  }

  Future<void> _updatePhoto(String photoData) async {
    setState(() => _isLoading = true);
    try {
      await UserService.updateProfile({'foto': photoData});
      _loadUserProfile();
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Widget _buildAvatar() {
    final String? photo = _userData?['foto'];
    
    if (photo == null || photo.isEmpty) {
      return const CircleAvatar(
        radius: 56,
        backgroundColor: Colors.white12,
        child: Icon(Icons.person, size: 50, color: Colors.white24),
      );
    }

    if (photo.startsWith('data:image')) {
      final base64Str = photo.split(',').last;
      return CircleAvatar(
        radius: 56,
        backgroundImage: MemoryImage(base64Decode(base64Str)),
      );
    }

    // Si es un código de icono (avatar de la selección)
    if (int.tryParse(photo) != null) {
      return CircleAvatar(
        radius: 56,
        backgroundColor: ColoresApp.rojoPrincipal.withOpacity(0.2),
        child: Icon(
          IconData(int.parse(photo), fontFamily: 'MaterialIcons'),
          size: 50,
          color: ColoresApp.rojoPrincipal,
        ),
      );
    }

    return CircleAvatar(
      radius: 56,
      backgroundImage: NetworkImage(photo),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundDark = ColoresApp.fondoOscuro;
    const Color cardDark = ColoresApp.fondoInput;
    const Color accentRed = ColoresApp.rojoPrincipal;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: backgroundDark,
        body: Center(child: CircularProgressIndicator(color: accentRed)),
      );
    }

    final String name = _userData?['nombre'] ?? 'Usuario';
    final String location = _userData?['ciudad'] ?? 'Loja, Ecuador';
    final String cedula = _userData?['cedula'] ?? '1100000000';

    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),

              /// Avatar
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: accentRed,
                      child: _buildAvatar(),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: accentRed,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                          onPressed: _cambiarFoto,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Rest of the screen...

              const SizedBox(height: 15),

              Text(
                name,
                style: const TextStyle(
                    color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),

              Text(
                location,
                style: const TextStyle(color: Colors.grey, fontSize: 15),
              ),

              const SizedBox(height: 10),

              /// ID
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                decoration: BoxDecoration(
                  color: accentRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: accentRed.withOpacity(0.4)),
                ),
                child: Text(
                  _userData?['rol'] == 'superadmin' ? "ACCESO TOTAL / SUPERADMIN" : "DNI/CÉDULA: $cedula",
                  style: const TextStyle(
                      color: accentRed, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),

              const SizedBox(height: 35),

              /// OPCIONES
              _buildOptionItem(
                context,
                icon: Icons.person_outline,
                title: "Datos Personales",
                bgColor: cardDark,
                onTap: () => Navigator.pushNamed(context, '/datos-personales'),
              ),

              _buildOptionItem(
                context,
                icon: Icons.security_outlined,
                title: "Seguridad de la Cuenta",
                bgColor: cardDark,
                onTap: () => Navigator.pushNamed(context, '/seguridad-cuenta'),
              ),

              _buildOptionItem(
                context,
                icon: Icons.contact_phone_outlined,
                title: "Gestionar Contactos",
                bgColor: cardDark,
                onTap: () => Navigator.pushNamed(context, '/gestionar-contactos'),
              ),

              _buildOptionItem(
                context,
                icon: Icons.notifications_outlined,
                title: "Preferencias de Notificación",
                bgColor: cardDark,
                onTap: () => Navigator.pushNamed(context, '/preferencias-notificacion'),
              ),

              const SizedBox(height: 35),

              /// CERRAR SESIÓN
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: OutlinedButton.icon(
                  onPressed: () => _mostrarDialogoCerrarSesion(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    side: const BorderSide(color: Colors.white10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  icon: const Icon(Icons.logout, color: accentRed),
                  label: const Text(
                    "Cerrar Sesión",
                    style: TextStyle(color: accentRed, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const UsuarioBottomNavWidget(currentIndex: 3),
    );
  }

  Widget _buildOptionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFE53935)),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _mostrarDialogoCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1212),
        title: const Text("Cerrar sesión", style: TextStyle(color: Colors.white)),
        content: const Text("¿Estás seguro de que deseas cerrar sesión?",
            style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar", style: TextStyle(color: ColoresApp.textoSecundario)),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.logout();
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, AppRutas.loginUsuario);
              }
            },
            child: const Text("Cerrar sesión", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
