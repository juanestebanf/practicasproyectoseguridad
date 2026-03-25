import 'package:flutter/material.dart';

class MapControlsWidget extends StatelessWidget {
  final VoidCallback? onAlertaPressed;

  const MapControlsWidget({
    super.key,
    this.onAlertaPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          mini: true,
          onPressed: onAlertaPressed,
          child: const Icon(Icons.my_location),
        ),
      ],
    );
  }
}