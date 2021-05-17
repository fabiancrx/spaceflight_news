import 'package:shared_preferences/shared_preferences.dart';

/// Class that stores in [SharedPreferences] a List of id's of the [New] that
/// the user marked as favorite.
class FavoritesService {
  final SharedPreferences _sharedPreferences;
  List<String> favorites;

  FavoritesService(this._sharedPreferences)
      : favorites = _sharedPreferences.getStringList(favoritesKey) ?? [];

  static const favoritesKey = 'favorite_new';

  void addFavorite(String id) {
    if (!favorites.contains(id)) {
      favorites.add(id);
      _sharedPreferences.setStringList(favoritesKey, favorites);
    }
  }

  void removeFavorite(String id) {
    if (favorites.remove(id)) {
      _sharedPreferences.setStringList(favoritesKey, favorites);
    }
  }
}
