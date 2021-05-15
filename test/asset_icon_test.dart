import 'dart:io';

import 'package:spaceflight_news/resources/resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('asset_icon assets test', () {
    expect(true, File(AssetIcon.add).existsSync());
    expect(true, File(AssetIcon.arrowBack).existsSync());
    expect(true, File(AssetIcon.bell).existsSync());
    expect(true, File(AssetIcon.bellActive).existsSync());
    expect(true, File(AssetIcon.calendar).existsSync());
    expect(true, File(AssetIcon.clear).existsSync());
    expect(true, File(AssetIcon.done).existsSync());
    expect(true, File(AssetIcon.edit).existsSync());
    expect(true, File(AssetIcon.empty).existsSync());
    expect(true, File(AssetIcon.error).existsSync());
    expect(true, File(AssetIcon.favorite).existsSync());
    expect(true, File(AssetIcon.favoriteOutline).existsSync());
    expect(true, File(AssetIcon.home).existsSync());
    expect(true, File(AssetIcon.login).existsSync());
    expect(true, File(AssetIcon.logout).existsSync());
    expect(true, File(AssetIcon.mail).existsSync());
    expect(true, File(AssetIcon.menu).existsSync());
    expect(true, File(AssetIcon.news).existsSync());
    expect(true, File(AssetIcon.person).existsSync());
    expect(true, File(AssetIcon.search).existsSync());
    expect(true, File(AssetIcon.upload).existsSync());
    expect(true, File(AssetIcon.visibility).existsSync());
    expect(true, File(AssetIcon.visibilityOff).existsSync());
  });
}
