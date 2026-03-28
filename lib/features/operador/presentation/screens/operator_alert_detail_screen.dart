import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:app_seguridadmx/features/operador/models/operator_alert_model.dart';
import 'package:app_seguridadmx/features/operador/services/operator_alert_service.dart';
import 'package:app_seguridadmx/features/operador/presentation/widgets/operator_priority_badge.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'package:app_seguridadmx/app/widgets/premium_widgets.dart';

class OperatorAlertDetailScreen extends StatefulWidget {
  final String alertId;
  const OperatorAlertDetailScreen({super.key, required this.alertId});

  @override
  State<OperatorAlertDetailScreen> createState() => _OperatorAlertDetailScreenState();
}

class _OperatorAlertDetailScreenState extends State<OperatorAlertDetailScreen> {
  final OperatorAlertService _service = OperatorAlertService();
  OperatorAlertModel? _alert;
  bool _loading = true;
  final TextEditingController _reportController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAlert();
  }

  Future<void> _loadAlert() async {
    final alert = await _service.fetchAlertDetails(widget.alertId);
    if (mounted) {
      setState(() {
        _alert = alert;
        _loading = false;
      });
    }
  }

  Future<void> _finalizarAlerta() async {
    final report = _reportController.text.trim();
    setState(() => _loading = true);
    final success = await _service.closeAlert(widget.alertId, report);
    if (!mounted) return;
    setState(() => _loading = false);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Alerta finalizada. El administrador recibirá el reporte."),
          backgroundColor: Colors.green,
        )
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Error al finalizar la alerta. Intente de nuevo."),
          backgroundColor: Colors.redAccent,
        )
      );
    }
  }

  Future<void> _assignAuthority(String tipo) async {
    try {
      final authorities = await _service.getAvailableAuthorities();
      if (authorities.isEmpty) {
        throw Exception("No hay unidades disponibles");
      }
      
      final authority = authorities.firstWhere(
        (a) => a.tipo == tipo,
        orElse: () => throw Exception("Unidad de tipo $tipo no encontrada"),
      );

      final success = await _service.assignAuthorityToAlert(widget.alertId, authority);
      
      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("🚨 Unidad de $tipo desplegada correctamente"), backgroundColor: Colors.blueAccent)
        );
        _loadAlert();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al desplegar unidad"), backgroundColor: Colors.redAccent)
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll("Exception: ", "")), backgroundColor: Colors.orange)
      );
    }
  }

  void _uploadEvidenceOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => GlassContainer(
        borderRadius: 20,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PremiumSectionTitle(title: "Subir Evidencia", icon: Icons.cloud_upload),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: ColoresApp.rojoPrincipal),
              title: const Text("Tomar Foto"),
              onTap: () { Navigator.pop(context); _takePhoto(); },
            ),
            ListTile(
              leading: const Icon(Icons.image, color: Colors.blueAccent),
              title: const Text("Galería de Imágenes"),
              onTap: () { Navigator.pop(context); _pickImage(); },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.orange),
              title: const Text("Documento PDF"),
              onTap: () { Navigator.pop(context); _pickPDF(); },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      _uploadFile(File(image.path));
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _uploadFile(File(image.path));
    }
  }

  Future<void> _pickPDF() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.isNotEmpty && result.files.first.path != null) {
      _uploadFile(File(result.files.first.path!));
    }
  }

  Future<void> _uploadFile(File file) async {
    setState(() => _loading = true);
    final success = await _service.uploadEvidence(widget.alertId, file);
    if (!mounted) return;
    setState(() => _loading = false);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ Evidencia subida con éxito"), backgroundColor: Colors.green));
      _loadAlert();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("❌ Error al subir evidencia"), backgroundColor: Colors.redAccent));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: ColoresApp.fondoOscuro,
        body: Center(child: CircularProgressIndicator(color: ColoresApp.rojoPrincipal)),
      );
    }

    if (_alert == null) {
      return Scaffold(
        backgroundColor: ColoresApp.fondoOscuro,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
              const SizedBox(height: 16),
              const Text("Error al cargar la alerta", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Es posible que la alerta ya no exista o haya un problema de conexión.", style: TextStyle(color: Colors.white38, fontSize: 13), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("VOLVER"),
              ),
            ],
          ),
        ),
      );
    }

    final alert = _alert!;

    return Scaffold(
      backgroundColor: ColoresApp.fondoOscuro,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("GESTIÓN DE INCIDENTE", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          /// 📦 CARD PRINCIPAL (GLASS)
          GlassContainer(
            padding: const EdgeInsets.all(20),
            borderRadius: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OperatorPriorityBadge(prioridad: alert.prioridad),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
                      child: Text(alert.estado.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(alert.titulo, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: ColoresApp.rojoPrincipal),
                    const SizedBox(width: 6),
                    Expanded(child: Text(alert.ubicacion, style: const TextStyle(color: ColoresApp.textoSecundario, fontSize: 13))),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// 🗺️ MAPA
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: LatLng(alert.lat, alert.lng), zoom: 16),
                markers: {Marker(markerId: MarkerId(alert.id), position: LatLng(alert.lat, alert.lng))},
                mapType: MapType.normal,
              ),
            ),
          ),

          const SizedBox(height: 32),

          /// 🔍 DETALLES TÉCNICOS
          const PremiumSectionTitle(title: "Detalles del Incidente", icon: Icons.assignment_outlined),
          const SizedBox(height: 16),
          GlassContainer(
            padding: const EdgeInsets.all(16),
            borderRadius: 15,
            child: Column(
              children: [
                _infoRow("Descripción", alert.descripcion),
                const Divider(color: Colors.white10, height: 24),
                _infoRow("Fecha/Hora", alert.fecha.toString().substring(0, 16)),
                const Divider(color: Colors.white10, height: 24),
                _infoRow("Informante", alert.ciudadano),
              ],
            ),
          ),

          const SizedBox(height: 32),

          /// 🚑 RESPUESTA Y AUTORIDADES
          const PremiumSectionTitle(title: "Desplegar Respuesta", icon: Icons.local_police_outlined),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _authorityChip("POLICIA", Icons.local_police),
                _authorityChip("BOMBEROS", Icons.fire_truck),
                _authorityChip("AMBULANCIA", Icons.medical_services),
                _authorityChip("SEGURIDAD", Icons.security),
              ],
            ),
          ),

          const SizedBox(height: 32),

          /// 📝 REPORTE Y EVIDENCIA
          const PremiumSectionTitle(title: "Acciones y Evidencia", icon: Icons.history_edu),
          const SizedBox(height: 16),
          
          if (alert.finalizada) ...[
            GlassContainer(
              padding: const EdgeInsets.all(16),
              borderRadius: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Esta alerta ya fue finalizada.", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (alert.reporteTexto != null && alert.reporteTexto!.isNotEmpty)
                    _infoRow("Notas", alert.reporteTexto!),
                  if (alert.reporteTexto != null && alert.reporteTexto!.isNotEmpty && alert.reporteFinal != null)
                    const Divider(color: Colors.white10, height: 24),
                  if (alert.reporteFinal != null)
                    _infoRow("Evidencia PDF", "Documento adjunto disponible"),
                  if ((alert.reporteTexto == null || alert.reporteTexto!.isEmpty) && alert.reporteFinal == null)
                    const Text("Sin documentación", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ] else ...[
            ElevatedButton.icon(
              onPressed: _uploadEvidenceOptions,
              icon: const Icon(Icons.upload_file_rounded),
              label: const Text("ADJUNTAR EVIDENCIA (IMG/PDF)"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white10,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _reportController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: "Escriba un reporte o comentario (Opcional)...",
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),

            const SizedBox(height: 24),

            /// 🏁 FINALIZAR
            ElevatedButton(
              onPressed: _finalizarAlerta,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColoresApp.rojoPrincipal,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 10,
                shadowColor: ColoresApp.rojoPrincipal.withOpacity(0.4),
              ),
              child: const Text("FINALIZAR ALERTA Y CERRAR CASO", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
            ),
          ],
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _authorityChip(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: ActionChip(
        avatar: Icon(icon, size: 16, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white.withOpacity(0.08),
        onPressed: () => _assignAuthority(label),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide.none),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 100, child: Text(label, style: const TextStyle(color: ColoresApp.textoSecundario, fontSize: 13))),
        Expanded(child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500))),
      ],
    );
  }
}