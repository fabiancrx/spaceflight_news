import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spaceflight_news/src/news/favorites_service.dart';

void main() {
  late FavoritesService favoritesService;

  setUp(() async {
    var tempDir = await getTemporaryDirectory();
    Hive.init(tempDir.path);
  });
  tearDown(() {});
  group('Check FavoritesService', () {});
}
