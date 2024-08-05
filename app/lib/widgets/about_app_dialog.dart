import 'package:film_log/widgets/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutAppDialog extends StatelessWidget {
  const AboutAppDialog({super.key});

  @override
  Widget build(BuildContext context) => AboutDialog(
        applicationName: AppLocalizations.of(context).appTitle,
        applicationIcon: const AppIcon(size: 48),
        applicationVersion: '1.0.0',
        children: [
          Text(AppLocalizations.of(context).aboutAppContent),
        ],
      );
}
