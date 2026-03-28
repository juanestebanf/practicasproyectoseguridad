import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/rutas/rutas_app.dart';
import 'package:flutter/material.dart';
import 'package:app_seguridadmx/features/operador/models/operator_model.dart';
import 'package:app_seguridadmx/features/operador/services/operator_alert_service.dart';
import 'package:app_seguridadmx/core/services/auth_service.dart';
import 'package:app_seguridadmx/core/services/user_service.dart';
import 'package:app_seguridadmx/app/widgets/avatar_selection_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

import 'package:app_seguridadmx/features/operador/presentation/widgets/operator_bottom_nav_widget.dart';
import 'package:app_seguridadmx/features/operador/presentation/widgets/operator_stat_card.dart';
import 'package:app_seguridadmx/features/operador/presentation/widgets/operator_section_title.dart';

class OperatorProfileScreen extends StatefulWidget {
  const OperatorProfileScreen({super.key});

  @override
  State<OperatorProfileScreen> createState() => _OperatorProfileScreenState();
}

class _OperatorProfileScreenState extends State<OperatorProfileScreen> {
  final OperatorAlertService _service = OperatorAlertService();
  final ImagePicker _picker = ImagePicker();
  OperatorModel? _operator;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final operator = await _service.fetchOperatorProfile();
    if (mounted) {
      setState(() {
        _operator = operator;
        _loading = false;
      });
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
    setState(() => _loading = true);
    try {
      await UserService.updateProfile({'foto': photoData});
      _loadProfile();
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Widget _buildAvatar() {
    final String? photo = _operator?.foto;
    
    if (photo == null || photo.isEmpty) {
      return const Icon(Icons.person, color: ColoresApp.rojoPrincipal, size: 35);
    }

    if (photo.startsWith('data:image')) {
      final base64Str = photo.split(',').last;
      return ClipOval(
        child: Image.memory(base64Decode(base64Str), fit: BoxFit.cover, width: 70, height: 70),
      );
    }

    if (int.tryParse(photo) != null) {
      return Icon(
        IconData(int.parse(photo), fontFamily: 'MaterialIcons'),
        size: 35,
        color: ColoresApp.rojoPrincipal,
      );
    }

    return ClipOval(
      child: Image.network(photo, fit: BoxFit.cover, width: 70, height: 70),
    );
  }

  void _logout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(AppRutas.loginUsuario, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = ColoresApp.fondoOscuro;
    if (_loading || _operator == null) {
      return const Scaffold(
        backgroundColor: bgColor,
        body: Center(child: CircularProgressIndicator(color: ColoresApp.rojoPrincipal)),
      );
    }

    final operator = _operator!;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(backgroundColor: bgColor, title: const Text("Perfil operador")),
      bottomNavigationBar: const OperatorBottomNavWidget(currentIndex: 2),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColoresApp.fondoInput,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5)),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _cambiarFoto,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: ColoresApp.rojoPrincipal.withOpacity(0.2),
                        child: _buildAvatar(),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: ColoresApp.rojoPrincipal,
                          child: const Icon(Icons.camera_alt, size: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(operator.nombre, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(operator.rol.toUpperCase(), style: const TextStyle(color: Colors.white60)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          const OperatorSectionTitle(title: "Estadísticas"),
          const SizedBox(height: 10),
          Row(
            children: [
              OperatorStatCard(title: "Alertas hoy", value: operator.estadisticas.alertasAtendidasHoy.toString(), icon: Icons.warning, color: Colors.orange),
              OperatorStatCard(title: "Eficiencia", value: "${operator.estadisticas.eficiencia}%", icon: Icons.trending_up, color: Colors.green),
              OperatorStatCard(title: "Tiempo resp.", value: operator.estadisticas.tiempoPromedioRespuesta, icon: Icons.timer, color: ColoresApp.info),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColoresApp.rojoPrincipal,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text("Cerrar sesión", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}