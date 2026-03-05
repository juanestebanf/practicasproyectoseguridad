import 'package:flutter/material.dart';

class AdminProfileAvatarWidget extends StatelessWidget {
  final String? imageUrl;

  const AdminProfileAvatarWidget({
    super.key,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    const accentRed = Color(0xFFE53935);
    const backgroundDark = Color(0xFF0D0D0D);

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
            backgroundColor: const Color(0xFF1A1A1A),
            backgroundImage:
                imageUrl != null ? NetworkImage(imageUrl!) : null,
            child: imageUrl == null
                ? const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white54,
                  )
                : null,
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
}