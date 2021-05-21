import 'package:flutter/cupertino.dart';
import 'package:spaceflight_news/src/news/model/new.dart';
import 'package:spaceflight_news/src/news/news_repository.dart';

/// Class that stores in [SharedPreferences] a List of id's of the [New] that
/// the user marked as favorite.
class FavoritesService extends ChangeNotifier {
  final NewsRepository _newsRepo;
  Future<List<New>?> favorites;

  FavoritesService(this._newsRepo) : favorites = _newsRepo.browse();

  void addFavorite(New news) async {
    final currentFavorites = await favorites;
    if (currentFavorites != null && !currentFavorites.any((element) => element.id == news.id)) {
      _newsRepo.insert(news);
      favorites = _newsRepo.browse();
      notifyListeners();
    }
  }

  void removeFavorite(New news) async {
    final currentFavorites = await favorites;

    if (currentFavorites != null && currentFavorites.any((element) => element.id == news.id)) {
      _newsRepo.delete(news.id);
      favorites = _newsRepo.browse();
      notifyListeners();
    }
  }

  /// Method that marks news as favorites depending on if they are in the [FavoritesService]
  Future<List<New>?> markFavorites(List<New>? rawNews) async {
    if (rawNews != null && rawNews.isNotEmpty) {
      var favorites = await this.favorites;

      for (var article in rawNews) {
        isNewFavorite(favorites, article);
      }
    }
    return rawNews;
  }
}

/// The concept of favorite does not exists in the API so in order to display this information
/// the incoming [New] that are stored locally as favorites should be marked as such
New isNewFavorite(List<New>? favorites, New news) {
  if (favorites != null && favorites.any((element) => element.id == news.id)) {
    news.isFavorite = true;
  }
  return news;
}
