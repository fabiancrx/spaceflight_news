import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spaceflight_news/src/news/favorites_service.dart';

void main() {
  late FavoritesService favoritesService;
  late SharedPreferences sp;
  setUp(() async {
    SharedPreferences.setMockInitialValues({
      FavoritesService.favoritesKey: <String>['41']
    });
    sp = await SharedPreferences.getInstance();

    favoritesService = FavoritesService(sp);
  });
  group('Check FavoritesService', () {
    test('FavoritesService correctly adds and removes items', () {
      expect(favoritesService.favorites.length, 1, reason: 'Loads previously stored data');
      favoritesService.addFavorite('42');
      expect(favoritesService.favorites.length, 2, reason: 'Adds an item');
      favoritesService.addFavorite('42');
      expect(favoritesService.favorites.length, 2, reason: 'Does not add duplicate items');
      favoritesService.removeFavorite('43');
      expect(favoritesService.favorites.length, 2, reason: 'Does not change if item to remove does not exists');
      favoritesService.removeFavorite('42');
      expect(favoritesService.favorites.length, 1, reason: 'Removes existing item');
    });
  });
}
