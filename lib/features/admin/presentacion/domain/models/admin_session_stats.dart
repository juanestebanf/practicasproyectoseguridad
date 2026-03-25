class AdminSessionStats {
  final int attendedToday;
  final int efficiency;
  final int responseTime;
  final DateTime shiftStart;

  AdminSessionStats({
    required this.attendedToday,
    required this.efficiency,
    required this.responseTime,
    required this.shiftStart,
  });
}