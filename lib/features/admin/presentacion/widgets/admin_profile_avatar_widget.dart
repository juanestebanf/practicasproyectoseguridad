import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';
import 'dart:convert';

class AdminProfileAvatarWidget extends StatelessWidget {
  final String? imageUrl;

  const AdminProfileAvatarWidget({
    super.key,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    const accentRed = ColoresApp.rojoPrincipal;
    const backgroundDark = ColoresApp.fondoOscuro;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: accentRed, width: 2),
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: ColoresApp.fondoInput,
            child: _buildInnerAvatar(imageUrl, accentRed),
          ),
        ),

        /// Estado en servicio
        Container(
          height: 22,
          width: 22,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
            border: Border.all(color: backgroundDark, width: 3),
          ),
        ),
      ],
    );
  }

  Widget _buildInnerAvatar(String? imageUrl, Color accentRed) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const Icon(Icons.person, size: 60, color: Colors.white54);
    }

    if (imageUrl.startsWith('data:image')) {
      final base64Str = imageUrl.split(',').last;
      return ClipOval(
        child: Image.memory(base64Decode(base64Str), fit: BoxFit.cover, width: 100, height: 100),
      );
    }

    if (int.tryParse(imageUrl) != null) {
      return Icon(
        IconData(int.parse(imageUrl), fontFamily: 'MaterialIcons'),
        size: 60,
        color: accentRed,
      );
    }

    return ClipOval(
      child: Image.network(
        imageUrl, 
        fit: BoxFit.cover, 
        width: 100, 
        height: 100, 
        errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 60, color: Colors.white54),
      ),
    );
  }
}