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

    return markFavorites(articles);
  }

  Future<List<New>?> search(String term) async {
    var articles = await spaceflightApi.search(term);

    return markFavorites(articles);
  }

  List<New>? markFavorites(List<New>? rawNews) {
    if (rawNews != null && rawNews.isNotEmpty) {
      var favorites = this.favoritesService.favorites;
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

class BottomBar extends ChangeNotifier {
  BottomBarItem state;

  BottomBar([BottomBarItem? initialState]) : state = initialState ?? BottomBarItem.feed;

  void toggle() {
    state = BottomBarItem.values[state.index + 1 % BottomBarItem.values.length];
    notifyListeners();
  }

  void changeIndex(int index) {
    if (index < BottomBarItem.values.length) {
      state = BottomBarItem.values[index];
      notifyListeners();
    } else {
      throw IndexError(index, BottomBarItem.values);
    }
  }
}

class SearchBarState extends ChangeNotifier {
  bool _isActive;
  String? _searchTerm;

  SearchBarState({String? searchTerm, bool isActive = false})
      : _searchTerm = searchTerm,
        _isActive = isActive;

  bool get isActive => _isActive;

  String? get searchTerm => _searchTerm;

  set searchTerm(String? term) {
    _searchTerm = term;
    notifyListeners();
  }

  void toggle() {
    _isActive = !_isActive;
    print('SearchBar active is $_isActive');
    notifyListeners();
  }
}
