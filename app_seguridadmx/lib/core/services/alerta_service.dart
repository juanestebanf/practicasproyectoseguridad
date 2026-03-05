import 'package:app_seguridadmx/core/models/alerta_model.dart';
import 'package:app_seguridadmx/core/utils/location_utils.dart'; 

class AlertaService {

  /// Simulación de alerta activa
  static bool _alertaActivaSimulada = false;

  /// Simulación de base de datos en memoria
  static final List<AlertaModel> _alertas = [
    AlertaModel(
      id: "1",
      tipoEmergencia: "ROBO",
      tipoAlerta: "Alarma Pública",
      sector: "Sector Loja, Ecuador",
      distancia: 35,
      fecha: DateTime.now().subtract(const Duration(minutes: 5)),
      lat: -4.0079,
      lng: -79.2042,
    ),
    AlertaModel(
      id: "2",
      tipoEmergencia: "Emergencia Médica",
      tipoAlerta: "Alarma Pública",
      sector: "Av. Universitaria",
      distancia: 120,
      fecha: DateTime.now().subtract(const Duration(minutes: 15)),
      lat: -4.0085,
      lng: -79.2050,
    ),
  ];

  /// Enviar alerta
  Future<bool> enviarAlerta({
    required String tipoEmergencia,
    required String tipoAlerta,
    required double lat,
    required double lng,
  }) async {

    if (_alertaActivaSimulada) return false;

    try {

      await Future.delayed(const Duration(seconds: 1));

      final nuevaAlerta = AlertaModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        tipoEmergencia: tipoEmergencia,
        tipoAlerta: tipoAlerta,
        sector: "Ubicación actual",
        distancia: 0,
        fecha: DateTime.now(),
        lat: lat,
        lng: lng,
      );

      _alertas.insert(0, nuevaAlerta);

      _alertaActivaSimulada = true;

      print("🚨 ALERTA EMITIDA");
      print("Tipo: $tipoEmergencia");
      print("Alcance: $tipoAlerta");

      return true;

    } catch (e) {

      print(" Error enviando alerta: $e");
      return false;

    }
  }

  /// Cancelar alerta
  Future<void> cancelarAlerta() async {

    await Future.delayed(const Duration(milliseconds: 500));
    _alertaActivaSimulada = false;

    print("Alerta cancelada");

  }

  /// Verificar alerta activa
  Future<bool> verificarAlertaActiva() async {
    return _alertaActivaSimulada;
  }

  /// Obtener historial
  static List<AlertaModel> obtenerHistorial() {
    return _alertas;
  }

  /// Obtener alertas (para notificaciones generales)
  static List<AlertaModel> obtenerAlertas() {
    return _alertas;
  }

  /// Obtener alertas cercanas (Filtro de 40 metros)
  static List<AlertaModel> obtenerAlertasCercanas(
    double userLat,
    double userLng,
  ) {
    return _alertas.where((alerta) {
      final distancia = LocationUtils.calcularDistancia(
        userLat,
        userLng,
        alerta.lat,
        alerta.lng,
      );

      return distancia <= 40;
    }).toList();
  }
}