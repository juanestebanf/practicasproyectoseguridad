import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class EstadoSistemaWidget extends StatelessWidget {
  const EstadoSistemaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PermissionStatus>(
      future: Permission.location.status,
      builder: (context, snapshot) {
        final isProtected = snapshot.data == PermissionStatus.granted;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isProtected ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
            border: Border.all(
              color: isProtected ? Colors.green.withOpacity(0.3) : Colors.orange.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isProtected ? Colors.green : Colors.orange,
                  boxShadow: [
                    BoxShadow(
                      color: isProtected ? Colors.green : Colors.orange,
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                isProtected ? 'SISTEMA PROTEGIDO' : 'ACTIVAR UBICACIÓN CLIENTE',
                style: TextStyle(
                  color: isProtected ? Colors.green.shade100 : Colors.orange.shade100,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}