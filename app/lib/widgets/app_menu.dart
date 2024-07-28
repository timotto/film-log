import 'package:film_log/pages/developer_settings_page/developer_settings_page.dart';
import 'package:film_log/pages/gear/gear_management_page/gear_management_page.dart';
import 'package:film_log/service/repos.dart';
import 'package:flutter/material.dart';

class AppMenu extends StatelessWidget {
  AppMenu({super.key, required this.repos, this.menuItems});

  final Repos repos;
  final List<Widget>? menuItems;

  final _controller = MenuController();

  void _toggleMenu() {
    if (_controller.isOpen) {
      _controller.close();
    } else {
      _controller.open();
    }
  }

  void _manageGear(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => GearManagementPage(
        cameraRepo: repos.cameraRepo,
        lensRepo: repos.lensRepo,
        filterRepo: repos.filterRepo,
        filmstockRepo: repos.filmstockRepo,
      ),
    ));
  }

  void _developerSettings(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => const DeveloperSettingsPage(),
    ));
  }

  @override
  Widget build(BuildContext context) => MenuAnchor(
        controller: _controller,
        menuChildren: [
          ...(menuItems ?? []),
          MenuItemButton(
            onPressed: () => _manageGear(context),
            leadingIcon: const Icon(Icons.settings),
            child: const Text('Manage gear'),
          ),
          MenuItemButton(
            onPressed: () => _developerSettings(context),
            leadingIcon: const Icon(Icons.build),
            child: const Text('Developer settings'),
          ),
        ],
        child: IconButton(
          onPressed: _toggleMenu,
          icon: const Icon(Icons.more_vert),
        ),
      );
}
