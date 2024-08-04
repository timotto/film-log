import 'package:film_log/widgets/app_icon.dart';
import 'package:flutter/material.dart';

class AboutAppDialog extends StatelessWidget {
  const AboutAppDialog({super.key});

  @override
  Widget build(BuildContext context) => const AboutDialog(
        applicationName: 'Film Log',
        applicationIcon: AppIcon(size: 48),
        applicationVersion: '1.0.0',
        children: [
          Text(
              'This app is intended for film photography users. It allows you to record time and place of each frame as well as the settings you used on your camera.'),
        ],
      );
}
