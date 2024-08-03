import 'package:film_log/service/wear_data.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../model/wear_os_device.dart';

class WearCompanionChecker extends StatefulWidget {
  const WearCompanionChecker({
    super.key,
    required this.wearDataService,
    required this.child,
  });

  final WearDataService wearDataService;
  final Widget child;

  @override
  State<WearCompanionChecker> createState() => _WearCompanionCheckerState();
}

class _WearCompanionCheckerState extends State<WearCompanionChecker> {
  final _log = Logger('wear-companion-checker');

  @override
  void initState() {
    _check(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.child;

  Future<void> _check(BuildContext context) async {
    try {
      final devices =
          await widget.wearDataService.findDevicesWithoutWearOsApp();
      if (devices.isEmpty || !context.mounted) return;

      _log.finest(
          'found ${devices.length} wear os devices without app: ${devices.map((d) => d.name).join(', ')}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Wear OS App available'),
          action: SnackBarAction(
            label: 'Install',
            onPressed: () => _install(context, devices),
          ),
        ),
      );
    } catch (e) {
      _log.info('find-devices failed', e);
    }
  }

  Future<void> _install(
    BuildContext context,
    List<WearOsDevice> devices,
  ) async {
    await widget.wearDataService.installWearOsApp(devices);
  }
}
