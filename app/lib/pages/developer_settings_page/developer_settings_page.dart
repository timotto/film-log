import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeveloperSettingsPage extends StatelessWidget {
  const DeveloperSettingsPage({super.key});

  Future<void> _deleteAllData(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Developer settings'),
        ),
        body: ListView(
          children: [
            ListTile(
              onTap: () => _deleteAllData(context),
              title: const Text('Delete all data'),
              leading: const Icon(Icons.delete_forever),
            )
          ],
        ),
      );
}
