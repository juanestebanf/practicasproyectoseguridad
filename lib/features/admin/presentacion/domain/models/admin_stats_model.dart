class AdminStatsModel {
  final int activeOperators;
  final int attendedToday;
  final int activeAlerts;
  final int avgResponseTime; // Tiempo promedio en segundos

  AdminStatsModel({
    required this.activeOperators,
    required this.attendedToday,
    required this.activeAlerts,
    required this.avgResponseTime,
  });

  String get avgResponseTimeFormatted {
    if (avgResponseTime == 0) return "N/A";
    final minutes = avgResponseTime ~/ 60;
    final seconds = avgResponseTime % 60;
    if (minutes > 0) {
      return "${minutes}m ${seconds}s";
    }
    return "${seconds}s";
  }
}