import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaceflight_news/main.dart';
import 'package:spaceflight_news/resources/resources.dart';
import 'package:spaceflight_news/src/common/extensions.dart';
import 'package:spaceflight_news/src/common/theme.dart';
import 'package:spaceflight_news/src/common/widget/no_data.dart';
import 'package:spaceflight_news/src/news/new.dart';
import 'package:spaceflight_news/src/news/viewmodel/feed_viewmodel.dart';

import 'news_card.dart';

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
final _noDataWidget = Provider.family<Widget, bool>((ref, isLoading) {
  var tab = ref.watch(_currentBottomBarItem);
  switch (tab.state) {
    case BottomBarItem.feed:
      return NoNews(isLoading: isLoading);
    case BottomBarItem.favorites:
      return NoFavorites(isLoading: isLoading);
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

        switch (bottomBar.state) {
          case BottomBarItem.feed:
            title = context.l10n.feed;
            subTitle = context.l10n.newsFeed;
            break;
          case BottomBarItem.favorites:
            title = context.l10n.favorites;
            subTitle = context.l10n.favoriteArticles;
            break;
        }

        return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(64),
                child: AppBar(
                  title: Text(title, style: TextStyles.h1),
                  centerTitle: false,
                  elevation: 0,
                  brightness: Brightness.light,
                  backwardsCompatibility: false,
                  systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Theme.of(context).backgroundColor,
                      statusBarIconBrightness: Theme.of(context).brightness.invert()),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Icon(Icons.search, size: 24),
                    )
                  ],
                )),
            bottomNavigationBar: BottomNavBar(),
            body: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
                ),
                child: watch(newsListProvider).map<Widget>(
                    data: (data) {
                      final news = data.value;
                      if (news == null || news.isEmpty) {
                        return watch(_noDataWidget(false));
                      }

                      return Column(
                        children: [
                          FeedHeader(text: subTitle),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: ListView(
                                shrinkWrap: false,
                                children: [
                                  for (var i = 0; i < news.length; i++) ...[
                                    if (i > 0) const SizedBox(height: 16),
                                    NewsCard(news: news[i]),
                                  ],
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    },
                    loading: (_) => watch(_noDataWidget(true)),
                    error: (error) => Center(
                          child: Text(error.toString()),
                        ))));
      },
    );
  }
}

class NoNews extends StatelessWidget {
  final bool isLoading;

  const NoNews({Key? key, this.isLoading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NoData(isLoading: isLoading, image: AssetImage(AssetIcon.notFoundNew), text: context.l10n.noNewsYet);
  }
}

class NoFavorites extends StatelessWidget {
  final bool isLoading;

  const NoFavorites({Key? key, this.isLoading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NoData(
      image: AssetImage(AssetIcon.notFoundHeart),
      isLoading: isLoading,
      text: context.l10n.favoritesNoResults,
      child: Row(
        children: [
          Text(
            context.l10n.favoriteTapOnThe,
            style: TextStyles.body2.copyWith(color: OnePlaceColor.gray800),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              Icons.favorite_border,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
          ),
          Text(
            context.l10n.favoriteToMarkAnItemAsFavorite,
            style: TextStyles.body2.copyWith(color: OnePlaceColor.gray800),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}

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
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            foregroundDecoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)))),
        Padding(
          padding: const EdgeInsets.only(bottom: 24, left: 16),
          child: Text(text, style: TextStyles.h2),
        )
      ],
    );
  }
}

/// A provider that exposes the current bottomBar
final _currentBottomBarItem = ChangeNotifierProvider((ref) => BottomBar());

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(context, watch) {
    var bottomBar = watch(_currentBottomBarItem);

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
          boxShadow: [
            BoxShadow(color: OnePlaceColor.blur, spreadRadius: 0, blurRadius: 20, offset: Offset(0, 10)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: BottomNavigationBar(
            backgroundColor: watch(theme).tabBackground,
            unselectedItemColor: OnePlaceColor.gray400,
            unselectedLabelStyle: TextStyles.tab3Inactive,
            selectedLabelStyle: TextStyles.tab3Active,
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
        ));
  }
}
