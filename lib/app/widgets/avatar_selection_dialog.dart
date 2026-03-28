import 'package:flutter/material.dart';
import 'package:app_seguridadmx/app/tema/colors_app.dart';

class AvatarSelectionDialog extends StatelessWidget {
  const AvatarSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> avatars = [
      {'icon': Icons.person_rounded, 'color': Colors.blue},
      {'icon': Icons.face_rounded, 'color': Colors.pink},
      {'icon': Icons.support_agent_rounded, 'color': Colors.orange},
      {'icon': Icons.admin_panel_settings_rounded, 'color': Colors.purple},
      {'icon': Icons.sentiment_satisfied_alt_rounded, 'color': Colors.green},
      {'icon': Icons.account_circle_rounded, 'color': Colors.teal},
      {'icon': Icons.pets_rounded, 'color': Colors.brown},
      {'icon': Icons.star_rounded, 'color': Colors.amber},
    ];

    return AlertDialog(
      backgroundColor: ColoresApp.fondoInput,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        "Seleccionar Avatar",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: avatars.length,
          itemBuilder: (context, index) {
            final avatar = avatars[index];
            return GestureDetector(
              onTap: () => Navigator.pop(context, avatar['icon'].codePoint.toString()),
              child: CircleAvatar(
                backgroundColor: (avatar['color'] as Color).withOpacity(0.2),
                child: Icon(avatar['icon'], color: avatar['color'], size: 30),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar", style: TextStyle(color: ColoresApp.textoSecundario)),
        ),
      ],
    );
  }
}
