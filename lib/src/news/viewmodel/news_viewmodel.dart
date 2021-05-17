import 'package:flutter/foundation.dart';
import 'package:spaceflight_news/src/common/api/spaceflight_api.dart';
import 'package:spaceflight_news/src/news/favorites_service.dart';
import 'package:spaceflight_news/src/news/new.dart';

enum BottomBarItem { feed, favorites }

class FeedViewModel extends ChangeNotifier {
  final SpaceflightApi spaceflightApi;
  final FavoritesService favoritesService;

  FeedViewModel({required this.spaceflightApi, required this.favoritesService});

  void toggleFavorite(New news) {
    news.isFavorite = !news.isFavorite;
    if (news.isFavorite) {
      favoritesService.addFavorite(news.id);
    } else {
      favoritesService.removeFavorite(news.id);
    }
    notifyListeners();
  }

  /// Get a list of all the news that the user has as favorites
  Future<List<New>?> getFavoriteNews() async {
    var favorites = this.favoritesService.favorites;
    if (favorites.isEmpty) {
      return List.empty();
    } else {
      List<Future<New?>> futureFavoriteArticles = [];
      for (var favorite in favorites) {
        futureFavoriteArticles.add(spaceflightApi.article(favorite));
      }
      var favoriteArticles = await Future.wait(futureFavoriteArticles);
      var _favoriteArticles = favoriteArticles.whereType<New>().map(markAsFavorite).toList();
      return _favoriteArticles;
    }
  }

  /// The difference from this method and [SpaceflightApi].articles() is that
  ///the retrieved news that are favorite are marked as such making it's `isFavorite` attribute `true`
  Future<List<New>?> getNews() async {
    var articles = await spaceflightApi.articles();
    if (articles != null && articles.isNotEmpty) {
      var favorites = this.favoritesService.favorites;
      for (var article in articles) {
        _isNewFavorite(favorites, article);
      }
    }
    return articles;
  }

  New _isNewFavorite(List<String> favoritesId, New news) {
    if (favoritesId.contains(news.id)) {
      news.isFavorite = true;
    }
    return news;
  }
}
