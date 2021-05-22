import 'package:flutter/foundation.dart';
import 'package:spaceflight_news/src/common/api/spaceflight_api.dart';
import 'package:spaceflight_news/src/news/favorites_service.dart';
import 'package:spaceflight_news/src/news/model/new.dart';

enum BottomBarItem { feed, favorites }

class FeedViewModel extends ChangeNotifier {
  final SpaceflightApi spaceflightApi;
  final FavoritesService favoritesService;

  FeedViewModel({required this.spaceflightApi, required this.favoritesService});

  void toggleFavorite(New news) {
    print(news);
    news.isFavorite = !news.isFavorite;
    print(news);
    if (news.isFavorite) {
      favoritesService.addFavorite(news);
    } else {
      favoritesService.removeFavorite(news);
    }
    notifyListeners();
  }

  /// Get a list of all the news that the user has as favorites
  Future<List<New>?> getFavoriteNews([String? searchTerm]) async {
    var favorites = await this.favoritesService.favorites;
    if (favorites == null || favorites.isEmpty) {
      return List.empty();
    } else {
      assert(favorites.every((element) => element.isFavorite));

      if (searchTerm != null) {
        // convert to lowerCase to do case insensitive matching
        return favorites
            .where((element) => element.title.toLowerCase().contains(
                  searchTerm.toLowerCase(),
                ))
            .toList();
      } else {
        return favorites;
      }
    }
  }

  /// The difference from this method and [SpaceflightApi].articles() is that
  ///the retrieved news that are favorite are marked as such making it's `isFavorite` attribute `true`
  Future<List<New>?> getNews({int? limit, int? offset,String? term}) async {
    var articles = await spaceflightApi.articles(start: offset, limit: limit,searchTerm: term);
    return markFavorites(articles);
  }

  Future<List<New>?> markFavorites(List<New>? rawNews) async {
    if (rawNews != null && rawNews.isNotEmpty) {
      var favorites = await this.favoritesService.favorites;

      for (var article in rawNews) {
        isNewFavorite(favorites, article);
      }
    }

    return rawNews;
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

    if (!_isActive) _searchTerm = null;

    notifyListeners();
  }
}
