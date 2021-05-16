import 'package:shared_preferences/shared_preferences.dart';

class FavoritesUseCase {
  final SharedPreferences _sharedPreferences;
  List<String> favorites;

  FavoritesUseCase(this._sharedPreferences)
      : favorites = _sharedPreferences.getStringList(_favoritesKey) ?? [];

  static const _favoritesKey = 'favorites';

  void addFavorite(String id) {
    if (!favorites.contains(id)) {
      favorites.add(id);
      _sharedPreferences.setStringList(_favoritesKey, favorites);
    }
  }

  void removeFavorite(String id) {
    if (favorites.remove(id)) {
      _sharedPreferences.setStringList(_favoritesKey, favorites);
    }
  }
}
