import 'package:film_log_wear/service/wear_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OpenOnPhoneButton extends StatelessWidget {
  const OpenOnPhoneButton({super.key});

  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
        onPressed: () => _openOnPhone(context),
        icon: const Icon(Icons.open_in_new),
        label: Text(AppLocalizations.of(context).openOnPhone),
      );

  Future<void> _openOnPhone(BuildContext context) async {
    final data = WearDataService();
    if (await data.openPhoneApp()) {
      return;
    }

    final devices = await data.findDevicesWithoutWearOsApp();
    if (devices.isEmpty) {
      return;
    }

    await data.installWearOsApp(devices);
  }
}
