import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';

class CustomSnackbar {
  static void show(BuildContext context, {required String message, required Color backgroundColor, required IconData icon}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        elevation: 10,
        duration: const Duration(seconds: 4),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    show(context, message: message, backgroundColor: ColoresApp.error, icon: Icons.error_outline_rounded);
  }

  static void showSuccess(BuildContext context, String message) {
    show(context, message: message, backgroundColor: ColoresApp.exito, icon: Icons.check_circle_outline_rounded);
  }

  static void showInfo(BuildContext context, String message) {
    show(context, message: message, backgroundColor: ColoresApp.info, icon: Icons.info_outline_rounded);
  }
}
