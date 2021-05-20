import 'package:shared_preferences/shared_preferences.dart';
import 'package:spaceflight_news/src/news/new.dart';

/// Class that stores in [SharedPreferences] a List of id's of the [New] that
/// the user marked as favorite.
class FavoritesService {
  final SharedPreferences _sharedPreferences;
  List<String> favorites;

  FavoritesService(this._sharedPreferences) : favorites = _sharedPreferences.getStringList(favoritesKey) ?? [];

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

  /// Method that marks news as favorites depending on if they are in the [FavoritesService]
  List<New>? markFavorites(List<New>? rawNews) {
    if (rawNews != null && rawNews.isNotEmpty) {
      var favorites = this.favorites;
      for (var article in rawNews) {
        _isNewFavorite(favorites, article);
      }
    }
    return rawNews;
  }

  New _isNewFavorite(List<String> favoritesId, New news) {
    if (favoritesId.contains(news.id)) {
      news.isFavorite = true;
    }
    return news;
  }
}
