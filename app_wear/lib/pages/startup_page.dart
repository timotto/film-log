import 'package:film_log_wear/widgets/swipe_dismiss.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SwipeDismiss(
          onDismissed: () => SystemNavigator.pop(),
          child: Center(
            child: Text(AppLocalizations.of(context).startUpPageStarting),
          ),
        ),
      );
}
