import 'package:film_log_wear/widgets/swipe_dismiss.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SwipeDismiss(
      onDismissed: () => SystemNavigator.pop(),
      child: const Center(
        child: Text('Starting...'),
      ),
    ),
  );
}