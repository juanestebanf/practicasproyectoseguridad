import '../models/alerta_model.dart';
import 'alerta_service.dart';

class AlertasServiceNotificacion {
  final AlertaService _alertaService = AlertaService();

  Future<List<AlertaModel>> obtenerAlertas() async {
    try {
      final alertas = await _alertaService.fetchUserHistory();
      // Filtrar por estado active o algo similar si es necesario
      // Por ahora, mostrar todas las del historial como notificaciones si no están leídas?
      // El código original filtraba por distancia <= 100
      return alertas.where((alerta) => alerta.distancia <= 100).toList();
    } catch (e) {
      return [];
    }
  }
}