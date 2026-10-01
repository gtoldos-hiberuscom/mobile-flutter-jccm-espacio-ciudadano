import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// WCAG 1.3.4 (orientación): la app no puede quedar fijada en vertical. Se
/// vigila la configuración de las tres capas que pueden bloquearla.
void main() {
  test('Flutter admite vertical y horizontal al arrancar', () {
    final bootstrap = File('lib/core/app/bootstrap.dart').readAsStringSync();
    expect(bootstrap, contains('DeviceOrientation.portraitUp'));
    expect(bootstrap, contains('DeviceOrientation.landscapeLeft'));
    expect(bootstrap, contains('DeviceOrientation.landscapeRight'));
  });

  test('iOS declara las orientaciones horizontales en iPhone', () {
    final plist = File('ios/Runner/Info.plist').readAsStringSync();
    final start = plist.indexOf('<key>UISupportedInterfaceOrientations</key>');
    expect(start, isNot(-1));
    final array = plist.substring(start, plist.indexOf('</array>', start));
    expect(array, contains('UIInterfaceOrientationPortrait'));
    expect(array, contains('UIInterfaceOrientationLandscapeLeft'));
    expect(array, contains('UIInterfaceOrientationLandscapeRight'));
  });

  test('Android no fija la orientación de la actividad', () {
    final manifest = File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
    expect(manifest, isNot(contains('android:screenOrientation="portrait"')));
    expect(manifest, isNot(contains('android:screenOrientation="sensorPortrait"')));
    expect(manifest, isNot(contains('android:screenOrientation="userPortrait"')));
  });
}
