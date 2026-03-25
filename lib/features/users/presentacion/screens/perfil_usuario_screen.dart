import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/features/users/presentacion/widgets/usuario_bottom_nav_widget.dart';
import 'package:app_seguridadmx/core/services/auth_service.dart';
import 'package:app_seguridadmx/rutas/rutas_app.dart';
import 'package:app_seguridadmx/core/services/user_service.dart';

class PerfilUsuarioScreen extends StatefulWidget {
  const PerfilUsuarioScreen({super.key});

  @override
  State<PerfilUsuarioScreen> createState() => _PerfilUsuarioScreenState();
}

class _PerfilUsuarioScreenState extends State<PerfilUsuarioScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

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
                      child: const CircleAvatar(
                        radius: 56,
                        backgroundImage: AssetImage('assets/user_photo.png'),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: accentRed,
                        child: IconButton(
                          icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),

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
                  "DNI/CÉDULA: $cedula",
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
