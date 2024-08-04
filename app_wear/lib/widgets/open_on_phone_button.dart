import 'package:flutter/material.dart';

import '../service/wear_data.dart';

class OpenOnPhoneButton extends StatelessWidget {
  const OpenOnPhoneButton({super.key});

  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
        onPressed: () => _openOnPhone(context),
        icon: const Icon(Icons.open_in_new),
        label: const Text('Open on Phone'),
      );

  Future<void> _openOnPhone(BuildContext context) async {
    final data = WearDataService();
    await data.openPhoneApp();
  }
}
