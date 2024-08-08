import 'package:flutter/material.dart';

class AcceptButton extends StatelessWidget {
  const AcceptButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: onPressed,
        icon: const Icon(Icons.check),
      );
}
