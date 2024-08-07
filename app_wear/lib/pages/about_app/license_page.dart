import 'package:film_log_wear/widgets/swipe_dismiss.dart';
import 'package:film_log_wear/widgets/wear_list_tile.dart';
import 'package:film_log_wear/widgets/wear_list_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WearOsLicensePage extends StatefulWidget {
  const WearOsLicensePage({super.key});

  @override
  State<WearOsLicensePage> createState() => _WearOsLicensePageState();
}

class _WearOsLicensePageState extends State<WearOsLicensePage> {
  final Future<_LicenseData> licenses = LicenseRegistry.licenses
      .fold<_LicenseData>(
        _LicenseData(),
        (_LicenseData prev, LicenseEntry license) => prev..addLicense(license),
      )
      .then((_LicenseData licenseData) => licenseData..sortPackages());

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SwipeDismiss(
          child: FutureBuilder(
            future: licenses,
            builder:
                (BuildContext context, AsyncSnapshot<_LicenseData> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    assert(() {
                      FlutterError.reportError(FlutterErrorDetails(
                        exception: snapshot.error!,
                        stack: snapshot.stackTrace,
                        context:
                            ErrorDescription('while decoding the license file'),
                      ));
                      return true;
                    }());
                    return Center(child: Text(snapshot.error.toString()));
                  }

                  return _packagesList(context, snapshot.data!);

                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      );

  Widget _packagesList(final BuildContext context, final _LicenseData data) =>
      WearListView.useDelegate(
        itemExtent: 64,
        childDelegate: data,
      );
}

class _LicenseData implements ListWheelChildDelegate {
  final List<LicenseEntry> licenses = <LicenseEntry>[];
  final Map<String, List<int>> packageLicenseBindings = <String, List<int>>{};
  final List<String> packages = <String>[];

  // Special treatment for the first package since it should be the package
  // for delivered application.
  String? firstPackage;

  void addLicense(LicenseEntry entry) {
    // Before the license can be added, we must first record the packages to
    // which it belongs.
    for (final String package in entry.packages) {
      _addPackage(package);
      // Bind this license to the package using the next index value. This
      // creates a contract that this license must be inserted at this same
      // index value.
      packageLicenseBindings[package]!.add(licenses.length);
    }
    licenses.add(entry); // Completion of the contract above.
  }

  /// Add a package and initialize package license binding. This is a no-op if
  /// the package has been seen before.
  void _addPackage(String package) {
    if (!packageLicenseBindings.containsKey(package)) {
      packageLicenseBindings[package] = <int>[];
      firstPackage ??= package;
      packages.add(package);
    }
  }

  /// Sort the packages using some comparison method, or by the default manner,
  /// which is to put the application package first, followed by every other
  /// package in case-insensitive alphabetical order.
  void sortPackages([int Function(String a, String b)? compare]) {
    packages.sort(compare ??
        (String a, String b) {
          // Based on how LicenseRegistry currently behaves, the first package
          // returned is the end user application license. This should be
          // presented first in the list. So here we make sure that first package
          // remains at the front regardless of alphabetical sorting.
          if (a == firstPackage) {
            return -1;
          }
          if (b == firstPackage) {
            return 1;
          }
          return a.toLowerCase().compareTo(b.toLowerCase());
        });
  }

  @override
  Widget? build(BuildContext context, int index) {
    if (index < 0 || index >= packages.length) return null;

    final package = packages[index];
    final licenses = packageLicenseBindings[package];

    return WearListTile(
      title: package,
      subtitle:
          AppLocalizations.of(context).countLicenses(licenses?.length ?? 0),
      onTap: (licenses?.length ?? 0) > 0
          ? () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => _WearOsLicenseViewPage(
                  package: package,
                  licenses: licenses!
                      .map((index) => this.licenses[index])
                      .toList(growable: false),
                ),
              ))
          : null,
    );
  }

  @override
  int? get estimatedChildCount => packages.length;

  @override
  bool shouldRebuild(covariant _LicenseData oldDelegate) =>
      packages.length != oldDelegate.packages.length;

  @override
  int trueIndexOf(int index) {
    return (index + packages.length) % packages.length;
  }
}

class _WearOsLicenseViewPage extends StatelessWidget {
  const _WearOsLicenseViewPage({
    required this.package,
    required this.licenses,
  });

  final String package;
  final List<LicenseEntry> licenses;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SwipeDismiss(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _header(context),
                  ...licenses
                      .map((item) => _license(context, item))
                      .reduce((a, b) => [
                            ...a,
                            _divider(context),
                            ...b,
                          ]),
                  _footer(context),
                ],
              ),
            ),
          ),
        ),
      );

  List<Widget> _license(BuildContext context, LicenseEntry entry) =>
      entry.paragraphs
          .map((p) => _paragraph(context, p))
          .toList(growable: false);

  Widget _paragraph(BuildContext context, LicenseParagraph paragraph) {
    if (paragraph.indent == LicenseParagraph.centeredIndent) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          paragraph.text,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: 4.0,
        start: 8.0 * paragraph.indent,
      ),
      child: Text(paragraph.text),
    );
  }

  Widget _header(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              package,
              textAlign: TextAlign.center,
            ),
            Text(
              AppLocalizations.of(context).countLicenses(licenses.length),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

  Widget _footer(BuildContext context) => ElevatedButton.icon(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back),
        label: Text(AppLocalizations.of(context).buttonBack),
      );

  Widget _divider(BuildContext context) => const Padding(
        padding: EdgeInsets.all(9.0),
        child: Divider(),
      );
}
