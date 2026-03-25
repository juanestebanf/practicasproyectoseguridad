import 'package:flutter/material.dart';

class HistoryCardWidget extends StatelessWidget {
  final String incidentId;
  final String title;
  final String subtitle;
  final String operator;
  final String operatorId;
  final String time;
  final String status;
  final bool isSuccess;
  final String role;

  const HistoryCardWidget({
    super.key,
    required this.incidentId,
    required this.title,
    required this.subtitle,
    required this.operator,
    required this.operatorId,
    required this.time,
    required this.status,
    required this.isSuccess,
    this.role = "OPERADOR",
  });

  @override
  Widget build(BuildContext context) {
    final statusColor =
        isSuccess ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text("INCIDENTE $incidentId",
                  style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(status,
                    style: TextStyle(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),

          Text(subtitle,
              style: const TextStyle(
                  color: Colors.grey, fontSize: 13)),

          const SizedBox(height: 15),
          const Divider(color: Colors.white10),
          const SizedBox(height: 10),

          Row(
            children: [
              const CircleAvatar(
                radius: 15,
                backgroundImage:
                    NetworkImage('https://via.placeholder.com/150'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(operator,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                    Text("$role ID: $operatorId",
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10)),
                  ],
                ),
              ),
              Text(time,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}