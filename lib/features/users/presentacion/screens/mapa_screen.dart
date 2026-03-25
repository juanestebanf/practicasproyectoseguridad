import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app_seguridadmx/features/users/presentacion/widgets/usuario_bottom_nav_widget.dart';
// 1️⃣ Importaciones del servicio y modelo
import 'package:app_seguridadmx/core/services/alerta_service.dart';
import 'package:app_seguridadmx/core/models/alerta_model.dart';
import 'package:app_seguridadmx/features/users/presentacion/widgets/map_controls_widget.dart';
import 'package:app_seguridadmx/features/users/presentacion/widgets/header_home_widget.dart';
import 'package:app_seguridadmx/core/services/socket_service.dart';

class MapaScreen extends StatefulWidget {
  final String? tipoEmergencia;
  final String? alcance;

  const MapaScreen({
    super.key,
    this.tipoEmergencia,
    this.alcance,
  });

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final AlertaService _alertaService = AlertaService();

  // 2️⃣ Set de marcadores
  Set<Marker> _marcadores = {};

  bool alertaActiva = false;
  bool puedeCancelar = true;
  String tiempoFormateado = "00:00";
  String? currentAlertId;
  GoogleMapController? _mapController;

  Timer? _timer;
  int _segundos = 0;
  StreamSubscription? _socketSubscription;

  String get tipoEmergencia => widget.tipoEmergencia ?? "";
  bool get esPublica => widget.alcance == 'publica';

  double lat = -4.0079;
  double lng = -79.2042;

  @override
  void initState() {
    super.initState();
    
    // 4️⃣ Cargar marcadores al iniciar
    _cargarMarcadores();

    // 📡 ESCUCHAR SOCKET EN TIEMPO REAL
    _socketSubscription = SocketService().alertStream.listen((data) {
      print("📡 Alerta recibida en MapaScreen: $data");
      _cargarMarcadores(); // Recargamos todo para asegurar consistencia
    });

    if (widget.tipoEmergencia != null && widget.alcance != null) {
      _enviarAlerta();
    }

    _centrarEnUsuario();
  }

  Future<void> _centrarEnUsuario() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition();
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            16,
          ),
        );
      }
    } catch (e) {
      print("Error al centrar mapa: $e");
    }
  }

  // 3️⃣ Método para convertir alertas en marcadores
  Future<void> _cargarMarcadores() async {
    // Obtenemos las alertas del historial mediante el servicio
    final alertas = await _alertaService.fetchUserHistory();

    final markers = alertas.map((alerta) {
      return Marker(
        markerId: MarkerId(alerta.id),
        position: LatLng(alerta.lat, alerta.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: alerta.tipoEmergencia,
          snippet: alerta.sector,
        ),
      );
    }).toSet();

    if (mounted) {
      setState(() {
        _marcadores = markers;
      });
    }
  }

  @override
  void dispose() {
    _detenerTimer();
    _socketSubscription?.cancel();
    super.dispose();
  }

  void _iniciarTimer() {
    _segundos = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _segundos++;
        int minutos = _segundos ~/ 60;
        int segundosRestantes = _segundos % 60;
        tiempoFormateado =
            "${minutos.toString().padLeft(2, '0')}:${segundosRestantes.toString().padLeft(2, '0')}";
      });
    });
  }

  void _detenerTimer() {
    _timer?.cancel();
  }

  Future<void> _enviarAlerta() async {
    final alertId = await _alertaService.enviarAlerta(
      tipoEmergencia: tipoEmergencia,
      tipoAlerta: esPublica ? "publica" : "privada",
      lat: lat,
      lng: lng,
    );

    if (alertId != null) {
      setState(() {
        alertaActiva = true;
        currentAlertId = alertId;
      });
      _iniciarTimer();
      // Recargamos marcadores por si la nueva alerta debe aparecer
      _cargarMarcadores(); 
    }
  }

  Future<void> _confirmarCancelacion() async {
    bool? resultado = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancelar alerta"),
        content: const Text("¿Estás seguro de cancelar la emergencia?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Sí, cancelar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (resultado == true) {
      await cancelarAlerta();
    }
  }

  Future<void> cancelarAlerta() async {
    if (currentAlertId == null) return;
    
    await _alertaService.cancelarAlerta(currentAlertId!);
    _detenerTimer();

    setState(() {
      alertaActiva = false;
      currentAlertId = null;
      _segundos = 0;
      tiempoFormateado = "00:00";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Alerta cancelada")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              initialCameraPosition: const CameraPosition(
                target: LatLng(-4.0079, -79.2042),
                zoom: 16,
              ),
              // 5️⃣ Pasar los marcadores al mapa
              markers: _marcadores,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xFF121212),
              child: const SafeArea(
                child: HeaderHomeWidget(),
              ),
            ),
          ),
          if (alertaActiva)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: AlertaActivaCard(
                tipo: tipoEmergencia,
                alcance: widget.alcance ?? "",
                tiempo: tiempoFormateado,
                puedeCancelar: puedeCancelar,
                onCancelar: _confirmarCancelacion,
              ),
            ),
        ],
      ),
      bottomNavigationBar: const UsuarioBottomNavWidget(currentIndex: 1),
      floatingActionButton: alertaActiva
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: _enviarAlerta,
              child: const Icon(Icons.warning),
            ),
    );
  }
}

// Widget AlertaActivaCard (sin cambios)
class AlertaActivaCard extends StatelessWidget {
  final String tipo;
  final String alcance;
  final String tiempo;
  final bool puedeCancelar;
  final VoidCallback onCancelar;

  const AlertaActivaCard({
    super.key,
    required this.tipo,
    required this.alcance,
    required this.tiempo,
    required this.puedeCancelar,
    required this.onCancelar,
  });

  String getTextoAlerta() {
    switch (tipo.toLowerCase()) {
      case 'robo': return "Robo / Asalto";
      case 'incendio': return "Incendio";
      case 'violencia': return "Violencia";
      case 'emergencia médica': return "Emergencia Médica";
      case 'sospechoso': return "Sospechoso";
      default: return tipo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            getTextoAlerta(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Alcance: $alcance • Tiempo: $tiempo',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          if (puedeCancelar)
            ElevatedButton(
              onPressed: onCancelar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
              ),
              child: const Text("Cancelar Alerta"),
            ),
        ],
      ),
    );
  }
}