import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/core/services/user_service.dart';

class DatosPersonalesScreen extends StatefulWidget {
  const DatosPersonalesScreen({super.key});

  @override
  State<DatosPersonalesScreen> createState() => _DatosPersonalesScreenState();
}

class _DatosPersonalesScreenState extends State<DatosPersonalesScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _sangreController = TextEditingController();
  final _nuevaAlergiaController = TextEditingController();

  List<String> _listaAlergias = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await UserService.getProfile();
      setState(() {
        _userData = data;
        _nombreController.text = data['nombre'] ?? '';
        _emailController.text = data['email'] ?? '';
        _telefonoController.text = data['telefono'] ?? '';
        _sangreController.text = data['tipo_sangre'] ?? '';
        
        final rawAlergias = data['alergias'] ?? '';
        _listaAlergias = rawAlergias.split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
            
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _saveData() async {
    setState(() => _isLoading = true);
    try {
      await UserService.updateProfile({
        'nombre': _nombreController.text.trim(),
        'email': _emailController.text.trim(),
        'telefono': _telefonoController.text.trim(),
        'tipo_sangre': _sangreController.text.trim(),
        'alergias': _listaAlergias.join(','),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos actualizados correctamente'), backgroundColor: Colors.green),
        );
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _agregarAlergia() {
    final texto = _nuevaAlergiaController.text.trim();
    if (texto.isNotEmpty) {
      setState(() {
        if (!_listaAlergias.contains(texto)) {
          _listaAlergias.add(texto);
        }
        _nuevaAlergiaController.clear();
      });
    }
  }

  void _eliminarAlergia(String tag) {
    setState(() {
      _listaAlergias.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    const backgroundDark = ColoresApp.fondoOscuro;
    const accentRed = ColoresApp.rojoPrincipal;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: backgroundDark,
        body: Center(child: CircularProgressIndicator(color: accentRed)),
      );
    }

    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark,
        elevation: 0,
        title: const Text(
          "Datos Personales", 
          style: TextStyle(
            color: ColoresApp.textoBlanco,
            fontWeight: FontWeight.bold
          )
        ),
        iconTheme: const IconThemeData(color: ColoresApp.textoBlanco),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("INFORMACIÓN BÁSICA"),
            _buildCustomTextField("Nombre completo", Icons.person_outline, _nombreController),
            _buildCustomTextField("Cédula / ID", Icons.badge_outlined, TextEditingController(text: _userData?['cedula'] ?? ''), enabled: false),
            _buildCustomTextField("Correo electrónico", Icons.email_outlined, _emailController),
            _buildCustomTextField("Teléfono", Icons.phone_android_outlined, _telefonoController),
            
            const SizedBox(height: 25),
            _sectionTitle("INFORMACIÓN MÉDICA"),
            _buildCustomTextField("Tipo de Sangre", Icons.bloodtype_outlined, _sangreController),
            
            const SizedBox(height: 10),
            _sectionTitle("ALERGIAS Y NOTAS MÉDICAS"),
            
            // Input para añadir nuevas alergias
            Container(
              decoration: BoxDecoration(color: ColoresApp.fondoInput, borderRadius: BorderRadius.circular(15)),
              child: TextField(
                controller: _nuevaAlergiaController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Agregar nueva nota o alergia...",
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                  prefixIcon: const Icon(Icons.add_circle_outline, color: ColoresApp.rojoPrincipal),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.check, color: Colors.greenAccent),
                    onPressed: _agregarAlergia,
                  ),
                ),
                onSubmitted: (_) => _agregarAlergia(),
              ),
            ),

            const SizedBox(height: 15),

            // Lista de tags de alergias
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _listaAlergias.map((alergia) => _buildAlergiaTag(alergia)).toList(),
            ),

            if (_listaAlergias.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 10, left: 5),
                child: Text(
                  "Sin notas médicas registradas",
                  style: TextStyle(color: Colors.white30, fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ),
              
            const SizedBox(height: 100), // Espacio para el FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: accentRed,
        onPressed: _isLoading ? null : _saveData,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text("Guardar Cambios", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 10, top: 10),
      child: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
    );
  }

  Widget _buildAlergiaTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: ColoresApp.rojoPrincipal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColoresApp.rojoPrincipal.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tag, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _eliminarAlergia(tag),
            child: const Icon(Icons.close, color: Colors.white54, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTextField(String label, IconData icon, TextEditingController controller, {bool enabled = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color: ColoresApp.fondoInput, borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        style: TextStyle(color: enabled ? Colors.white : Colors.grey),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: ColoresApp.rojoPrincipal),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }
}