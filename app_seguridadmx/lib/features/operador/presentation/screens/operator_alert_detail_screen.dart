import 'dart:io';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:app_seguridadmx/features/operador/models/operator_alert_model.dart';
import 'package:app_seguridadmx/features/operador/services/operator_alert_service.dart';

import 'package:app_seguridadmx/features/operador/presentation/widgets/operator_priority_badge.dart';
import 'package:app_seguridadmx/features/operador/presentation/widgets/operator_section_title.dart';

class OperatorAlertDetailScreen extends StatefulWidget {

  final String alertId;

  const OperatorAlertDetailScreen({
    super.key,
    required this.alertId,
  });

  @override
  State<OperatorAlertDetailScreen> createState() =>
      _OperatorAlertDetailScreenState();
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

    setState(() {
      _alert = alert;
      _loading = false;
    });
  }

  /// FINALIZAR ALERTA

  Future<void> _finalizarAlerta() async {

    final report = _reportController.text.trim();

    final success = await _service.closeAlert(widget.alertId, report);

    if(!mounted) return;

    if(success){

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Alerta finalizada")),
      );

      Navigator.pop(context,true);

    }else{

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debe escribir un reporte")),
      );

    }
  }

  /// ASIGNAR AUTORIDAD

  Future<void> _assignAuthority(String tipo) async {

    final authorities = await _service.getAvailableAuthorities();

    final authority = authorities.firstWhere((a) => a.tipo == tipo);

    await _service.assignAuthorityToAlert(widget.alertId, authority);

    _loadAlert();
  }

  /// SUBIR EVIDENCIA

  void _uploadEvidenceOptions(){

    showModalBottomSheet(
      context: context,
      builder: (_) {

        return SafeArea(

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Tomar foto"),
                onTap: (){
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),

              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Seleccionar imagen"),
                onTap: (){
                  Navigator.pop(context);
                  _pickImage();
                },
              ),

              ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text("Subir PDF"),
                onTap: (){
                  Navigator.pop(context);
                  _pickPDF();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _takePhoto() async {

    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.camera,
    );

    if(image != null){

      final file = File(image.path);

      await _service.uploadEvidence(widget.alertId,file);

      _loadAlert();
    }
  }

  Future<void> _pickImage() async {

    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if(image != null){

      final file = File(image.path);

      await _service.uploadEvidence(widget.alertId,file);

      _loadAlert();
    }
  }

  Future<void> _pickPDF() async {

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if(result != null){

      final file = File(result.files.single.path!);

      await _service.uploadEvidence(widget.alertId,file);

      _loadAlert();
    }
  }

  @override
  Widget build(BuildContext context) {

    const bgColor = Color(0xFF0D0D0D);

    if(_loading){

      return const Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFE53935),
          ),
        ),
      );
    }

    final alert = _alert!;

    return Scaffold(

      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text("Detalle de alerta"),
      ),

      body: ListView(

        padding: const EdgeInsets.all(16),

        children: [

          /// HEADER ALERTA

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Expanded(
                child: Text(
                  alert.titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              OperatorPriorityBadge(
                prioridad: alert.prioridad,
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            alert.ubicacion,
            style: const TextStyle(
              color: Colors.white60,
            ),
          ),

          const SizedBox(height: 20),

          /// MAPA

          SizedBox(
            height: 220,

            child: ClipRRect(

              borderRadius: BorderRadius.circular(12),

              child: GoogleMap(

                initialCameraPosition: CameraPosition(
                  target: LatLng(alert.lat, alert.lng),
                  zoom: 16,
                ),

                markers: {
                  Marker(
                    markerId: MarkerId(alert.id),
                    position: LatLng(alert.lat, alert.lng),
                  )
                },
              ),
            ),
          ),

          const SizedBox(height: 24),

          /// REGISTRO INCIDENTE

          const OperatorSectionTitle(
            title: "Registro de incidente",
          ),

          const SizedBox(height: 10),

          _info("Descripción", alert.descripcion),
          _info("Fecha", alert.fecha.toString()),
          _info("Estado", alert.estado),

          const SizedBox(height: 24),

          /// INFORMANTE

          const OperatorSectionTitle(
            title: "Datos del informante",
          ),

          const SizedBox(height: 10),

          _info("Ciudadano", alert.ciudadano),

          const SizedBox(height: 24),

          /// ASIGNAR RESPUESTA

          const OperatorSectionTitle(
            title: "Asignar respuesta",
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 10,
            children: [

              _authorityButton("POLICIA"),
              _authorityButton("BOMBEROS"),
              _authorityButton("AMBULANCIA"),
              _authorityButton("SEGURIDAD"),

            ],
          ),

          const SizedBox(height: 24),

          /// EVIDENCIA

          ElevatedButton.icon(

            onPressed: _uploadEvidenceOptions,

            icon: const Icon(Icons.upload),

            label: const Text("Subir evidencia"),

          ),

          const SizedBox(height: 24),

          /// REPORTE FINAL

          const OperatorSectionTitle(
            title: "Reporte final",
          ),

          const SizedBox(height: 10),

          TextField(
            controller: _reportController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Escribir reporte...",
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF161616),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(height: 24),

          /// FINALIZAR ALERTA

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _finalizarAlerta,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
              ),
              child: const Text("FINALIZAR ALERTA"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _authorityButton(String label){

    return ElevatedButton(
      onPressed: (){
        _assignAuthority(label);
      },
      child: Text(label),
    );
  }

  Widget _info(String label,String value){

    return Padding(
      padding: const EdgeInsets.symmetric(vertical:6),
      child: Row(
        children: [

          Expanded(
            flex:3,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
              ),
            ),
          ),

          Expanded(
            flex:5,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}