import '../models/alerta_model.dart';
import 'alerta_service.dart';

class AlertasServiceNotificacion {

  static List<AlertaModel> obtenerAlertas() {

    final alertas = AlertaService.obtenerAlertas();

    /// Solo mostrar alertas cercanas (< 100m)
    return alertas.where((alerta) => alerta.distancia <= 100).toList();

  }

}