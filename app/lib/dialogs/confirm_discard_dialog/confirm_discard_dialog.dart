import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmDiscardDialog extends StatelessWidget {
  const ConfirmDiscardDialog({super.key});

  static Future<bool> show(BuildContext context) async =>
      (await showDialog<bool>(
          context: context, builder: (_) => const ConfirmDiscardDialog())) ??
      false;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(AppLocalizations.of(context).dialogDiscardChangesTitle),
        content: Text(AppLocalizations.of(context).dialogDiscardChangesText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context).buttonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context).buttonDiscard),
          ),
        ],
      );
}
