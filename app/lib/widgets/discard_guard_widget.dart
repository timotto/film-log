import 'package:film_log/dialogs/confirm_discard_dialog/confirm_discard_dialog.dart';
import 'package:flutter/material.dart';

class DiscardGuardWidget extends StatelessWidget {
  const DiscardGuardWidget({
    super.key,
    required this.hasChanges,
    required this.child,
  });

  final bool Function() hasChanges;
  final Widget child;

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: _canPop(),
        onPopInvoked: (didPop) => _onPopInvoked(context, didPop),
        child: child,
      );

  bool _canPop() => !hasChanges();

  Future<void> _onPopInvoked(BuildContext context, bool? didPop) async {
    if (didPop ?? false) return;
    if (!hasChanges()) return;

    if (!await ConfirmDiscardDialog.show(context)) return;

    if (!context.mounted) return;

    Navigator.of(context).pop();
  }
}
