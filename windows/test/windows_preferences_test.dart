import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:sync_ui/sync_ui.dart';
import 'package:synchronizer_windows/device_identity.dart';
import 'package:synchronizer_windows/windows_preferences.dart';

void main() {
  test('reads and writes the previous Windows preferences file', () async {
    final roaming = await Directory.systemTemp.createTemp('mica-prefs-');
    final originalStore = SharedPreferencesStorePlatform.instance;
    addTearDown(() async {
      SharedPreferences.resetStatic();
      SharedPreferencesStorePlatform.instance = originalStore;
      await roaming.delete(recursive: true);
    });

    final previousPrefs = File(
      p.join(roaming.path, 'Axawys', 'Synchronizer', 'shared_preferences.json'),
    );
    final previousValues = {
      'flutter.device_id': 'existing-id',
      'flutter.device_name': 'Old Windows PC',
      'flutter.trusted_peers': jsonEncode([
        {
          'id': 'mobile',
          'name': 'Phone',
          'platform': 'android',
          'secret': 'key',
        },
      ]),
      'flutter.shared_folders': jsonEncode([
        {'name': 'Notes', 'path': p.join(roaming.path, 'Notes')},
      ]),
      'flutter.color_scheme': 'synchronizer',
    };
    await previousPrefs.create(recursive: true);
    await previousPrefs.writeAsString(jsonEncode(previousValues));

    SharedPreferences.resetStatic();
    configureWindowsPreferences(roamingPath: () async => roaming.path);
    final device = await DeviceIdentity.load();
    final folders = SharedFolders();
    addTearDown(folders.dispose);
    await folders.load();
    expect(device.id, 'existing-id');
    expect(device.name, 'Old Windows PC');
    expect(folders.pathOf('Notes'), p.join(roaming.path, 'Notes'));
    expect((await PrefsTrustStore().get('mobile'))?.secret, 'key');

    final prefs = await SharedPreferences.getInstance();
    expect(await prefs.setString('theme_mode', 'dark'), isTrue);
    expect(jsonDecode(await previousPrefs.readAsString()), {
      ...previousValues,
      'flutter.theme_mode': 'dark',
    });
  });
}
