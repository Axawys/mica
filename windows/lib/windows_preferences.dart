import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider_windows/path_provider_windows.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:shared_preferences_windows/shared_preferences_windows.dart';
import 'package:win32/win32.dart' show FOLDERID_RoamingAppData;

void configureWindowsPreferences({Future<String?> Function()? roamingPath}) {
  final preferences = SharedPreferencesWindows();
  // Keep the original store when the executable's ProductName changes.
  // ignore: invalid_use_of_visible_for_testing_member
  preferences.pathProvider = _PreferencesPath(roamingPath ?? _roamingAppData);
  SharedPreferencesStorePlatform.instance = preferences;
}

Future<String?> _roamingAppData() =>
    PathProviderWindows().getPath(FOLDERID_RoamingAppData);

class _PreferencesPath extends PathProviderWindows {
  _PreferencesPath(this._roamingPath);

  final Future<String?> Function() _roamingPath;

  @override
  Future<String?> getApplicationSupportPath() async {
    final roaming = await _roamingPath();
    if (roaming == null) return null;

    final directory = Directory(p.join(roaming, 'Axawys', 'Synchronizer'));
    await directory.create(recursive: true);
    return directory.path;
  }
}
