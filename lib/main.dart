import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spaceflight_news/src/common/api/spaceflight_api.dart';
import 'package:spaceflight_news/src/common/extensions.dart';
import 'package:spaceflight_news/src/common/widget/no_data.dart';
import 'package:spaceflight_news/src/environment.dart';
import 'package:spaceflight_news/src/news/favorites_service.dart';
import 'package:spaceflight_news/src/news/new.dart';
import 'package:spaceflight_news/src/news/viewmodel/news_viewmodel.dart';

import 'resources/resources.dart';
import 'src/news/news_card.dart';

/// How to override
/// ```
///     ProviderScope(
///       overrides: [
///         sharedPreferences.overrideWithValue(_newValue),
///      ],
///  ```
final sharedPreferences = Provider<SharedPreferences>((ref) {
  throw UnimplementedError("This provider is meant to be overriden by a providerScope "
      "WHY: to provide the database in a synchronous manner to the subtree");
});

var environment = Provider((_) => Environment.production());
var api = Provider((ref) => SpaceflightApi(environment: ref.watch(environment)));
var favoritesService = Provider((ref) => FavoritesService(ref.watch(sharedPreferences)));
var feedViewModel = ChangeNotifierProvider(
    (ref) => FeedViewModel(spaceflightApi: ref.watch(api), favoritesService: ref.watch(favoritesService)));

void main() async {
  var _sharedPreferences = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    overrides: [sharedPreferences.overrideWithValue(_sharedPreferences)],
    child: MaterialApp(
        onGenerateTitle: (BuildContext context) => context.l10n.appTitle,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: NewsFeed()),
  ));
}

/// A provider that exposes only the current bottomBar
final _currentBottomBarItem = ChangeNotifierProvider((ref) => BottomBar());

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

final newsListProvider = FutureProvider<List<New>?>((ref) {
  final tab = ref.watch(_currentBottomBarItem);

  final _feedViewModel = ref.read(feedViewModel);
  switch (tab.state) {
    case BottomBarItem.feed:
      return _feedViewModel.getNews();
    case BottomBarItem.favorites:
      return _feedViewModel.getFavoriteNews();
  }
});

class NewsFeed extends StatelessWidget {
  const NewsFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        var bottomBar = watch(_currentBottomBarItem);
        var _feedViewModel = watch(feedViewModel);

        late String title;
        late String subTitle;
        late Widget noData;
        switch (BottomBarItem.values[bottomBar.state.index]) {
          case BottomBarItem.feed:
            title = context.l10n.feed;
            subTitle = context.l10n.newsFeed;
            noData = _noNews(context);
            break;
          case BottomBarItem.favorites:
            title = context.l10n.favorites;
            subTitle = context.l10n.favoriteArticles;
            noData = _noFavorites(context);
            break;
        }

        return Scaffold(
            appBar: AppBar(
              title: Text(title),
              centerTitle: false,
              elevation: 0,
              actions: [Image.asset(AssetIcon.search)],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: context.l10n.feed,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: context.l10n.favorites,
                ),
              ],
              currentIndex: bottomBar.state.index,
              onTap: bottomBar.changeIndex,
            ),
            body: watch(newsListProvider).map<Widget>(
                data: (data) {
                  final news = data.value;
                  if (news == null || news.isEmpty) {
                    return noData;
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView(
                      children: [
                        FeedHeader(text: subTitle),
                        for (var i = 0; i < news.length; i++) ...[
                          if (i > 0) const SizedBox(height: 16),
                          NewsCard(news: news[i]),
                        ],
                      ],
                    ),
                  );
                },
                loading: (_) => noData,
                error: (error) => Center(
                      child: Text(error.toString()),
                    )));
      },
    );
  }
}

Widget _noNews(BuildContext context) =>
    NoData(image: AssetImage(AssetIcon.notFoundNew), message: context.l10n.noNewsYet);

Widget _noFavorites(BuildContext context) =>
    NoData(image: AssetImage(AssetIcon.notFoundHeart), message: context.l10n.favoritesNoResults);

class FeedHeader extends StatelessWidget {
  final String text;

  const FeedHeader({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            height: 20,
            foregroundDecoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)))),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(text),
        )
      ],
    );
  }
}
