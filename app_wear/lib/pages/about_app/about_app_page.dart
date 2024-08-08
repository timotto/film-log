import 'package:film_log_wear/widgets/swipe_dismiss.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'license_page.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SwipeDismiss(
          child: Center(
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Theme.of(context).colorScheme.primary,
                    child: Text(
                      AppLocalizations.of(context).appTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(AppLocalizations.of(context).aboutAppText),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _showLicensePage(context),
                    child: Text(
                      AppLocalizations.of(context).buttonShowLicenses,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Future<void> _showLicensePage(BuildContext context) async =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const WearOsLicensePage(),
        ),
      );
}
