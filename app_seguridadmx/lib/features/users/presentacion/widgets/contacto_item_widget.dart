import 'package:flutter/material.dart';

class ContactoItemWidget extends StatelessWidget {
  final Map<String, dynamic> contacto;
  final VoidCallback onTap;

  const ContactoItemWidget({
    super.key,
    required this.contacto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color cardDark = Color(0xFF1E1E1E);
    const Color accentRed = Color(0xFFE53935);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white.withOpacity(0.05),
          child: Text(
            contacto['iniciales'],
            style: TextStyle(
              color: contacto['seleccionado']
                  ? accentRed
                  : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          contacto['nombre'],
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          contacto['telefono'],
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Icon(
          contacto['seleccionado']
              ? Icons.check_circle
              : Icons.radio_button_unchecked,
          color: contacto['seleccionado']
              ? accentRed
              : Colors.grey.withOpacity(0.3),
          size: 28,
        ),
        onTap: onTap,
      ),
    );
  }
}