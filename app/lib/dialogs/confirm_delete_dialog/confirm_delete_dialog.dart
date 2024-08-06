import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  const ConfirmDeleteDialog({super.key, required this.label});

  static Future<bool> show(BuildContext context, String label) async =>
      (await showDialog<bool>(
        context: context,
        builder: (_) => ConfirmDeleteDialog(
          label: label,
        ),
      )) ??
      false;

  final String label;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context).dialogConfirmDeleteTitle(label),
        ),
        content: Text(
          AppLocalizations.of(context).dialogConfirmDeleteText(label),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context).buttonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context).buttonDelete),
          ),
        ],
      );
}
