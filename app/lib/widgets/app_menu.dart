import 'package:film_log/pages/gear/gear_management_page/gear_management_page.dart';
import 'package:film_log/service/repos.dart';
import 'package:film_log/widgets/about_app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  Future<void> _aboutApp(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => const AboutAppDialog(),
    );
  }

  @override
  Widget build(BuildContext context) => MenuAnchor(
        controller: _controller,
        menuChildren: [
          ...(menuItems ?? []),
          MenuItemButton(
            onPressed: () => _manageGear(context),
            leadingIcon: const Icon(Icons.camera_alt),
            child: Text(AppLocalizations.of(context).menuItemManageGear),
          ),
          MenuItemButton(
            onPressed: () => _aboutApp(context),
            leadingIcon: const Icon(Icons.info),
            child: Text(AppLocalizations.of(context).menuItemAboutApp),
          ),
        ],
        child: IconButton(
          onPressed: _toggleMenu,
          icon: const Icon(Icons.more_vert),
        ),
      );
}
