import 'package:flutter/material.dart';

class SwipeDismiss extends StatelessWidget {
  SwipeDismiss({super.key, required this.child, this.onDismissed});

  final _key = GlobalKey();

  final Widget child;
  final VoidCallback? onDismissed;

  @override
  Widget build(BuildContext context) => Dismissible(
        key: _key,
        direction: DismissDirection.startToEnd,
        onDismissed: (_) => _onDismissed(context),
        child: child,
      );

  void _onDismissed(BuildContext context) =>
      onDismissed != null ? onDismissed!() : Navigator.of(context).pop();
}
