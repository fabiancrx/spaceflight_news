import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spaceflight_news/main.dart';
import 'package:spaceflight_news/src/common/extensions.dart';
import 'package:spaceflight_news/src/common/theme.dart';
import 'package:spaceflight_news/src/common/widget/no_data.dart';
import 'package:spaceflight_news/src/news/model/new.dart';
import 'package:spaceflight_news/src/news/viewmodel/feed_viewmodel.dart';
import 'package:spaceflight_news/src/news/widget/no_data_adapters.dart';
import 'package:spaceflight_news/src/news/widget/search.dart';

import 'news_card.dart';

/// A provider that exposes the current bottomBar
final _currentBottomBarTabProvider = ChangeNotifierProvider((ref) => BottomBar());

/// A provider that exposes the SearchBar state
final searchBarProvider = ChangeNotifierProvider((ref) => SearchBarState());

/// The future that the [FeedPage] will await to display tne [List<New>]
final newsListProvider = FutureProvider<List<New>?>((ref) {
  final tab = ref.watch(_currentBottomBarTabProvider);

  final search = ref.watch(searchBarProvider);
  final _feedViewModel = ref.read(feedViewModel);

  if (search.isActive) {
    if (search.searchTerm != null) {
      switch (tab.state) {
        case BottomBarItem.feed:
          return _feedViewModel.getNews(term: search.searchTerm!);
        case BottomBarItem.favorites:
          return _feedViewModel.getFavoriteNews(search.searchTerm);
      }
    }
    return Future.value([]);
  }

  switch (tab.state) {
    case BottomBarItem.feed:
      return _feedViewModel.getNews();
    case BottomBarItem.favorites:
      return _feedViewModel.getFavoriteNews();
  }
});

/// A provider for the widget that will be shown when the [FeedPage] has no data.
/// The [isLoading] property corresponds to the [NoData] widget.
final _noDataWidgetProvider = Provider.family<Widget, bool>((ref, isLoading) {
  var tab = ref.watch(_currentBottomBarTabProvider);
  final search = ref.watch(searchBarProvider);

  if (search.isActive) {
    return NoSearchResults(
      isLoading: isLoading,
    );
  }

  switch (tab.state) {
    case BottomBarItem.feed:
      return NoNews(isLoading: isLoading);
    case BottomBarItem.favorites:
      return NoFavorites(isLoading: isLoading);
  }
});

class NewsFeed extends HookConsumerWidget {
  const NewsFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var bottomBar = ref.watch(_currentBottomBarTabProvider);
    var _feedViewModel = ref.watch(feedViewModel);

    var search = ref.watch(searchBarProvider);
    double appBarHeight = 64 + (search.isActive ? 60 : 0);

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

    final PreferredSizeWidget? bottomAppBarWidget =
        search.isActive ? PreferredSize(preferredSize: Size.fromHeight(40), child: SearchBar()) : null;

    return Scaffold(
        key: Key('feed_page'),
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(appBarHeight),
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
                IconButton(icon: Icon(search.isActive ? Icons.clear : Icons.search, size: 24), onPressed: search.toggle)
              ],
              bottom: bottomAppBarWidget,
            )),
        bottomNavigationBar: BottomNavBar(),
        body: Container(
          color: Theme.of(context).primaryColor,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
                ),
                child: ref.watch(newsListProvider).map<Widget>(
                    data: (data) => _NewsList(data.value, subTitle),
                    loading: (_) => ref.watch(_noDataWidgetProvider(true)),
                    error: (error) => _ErrorWidget())),
          ),
        ));
  }
}

class _NewsList extends HookConsumerWidget {
  final List<New>? news;
  final String subtitle;

  const _NewsList(
    this.news,
    this.subtitle, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (news == null || news!.isEmpty) {
      return ref.watch(_noDataWidgetProvider(false));
    }

    return RefreshIndicator(
      onRefresh: () {
        return ref.refresh(newsListProvider.future);
      },
      child: Column(
        key: Key('news_list_data'),
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24, left: 18, top: 20),
              child: Text(subtitle, style: TextStyles.h2),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                shrinkWrap: false,
                children: [for (var i = 0; i < news!.length; i++) NewsCard(news: news![i])],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _ErrorWidget extends ConsumerWidget {
  const _ErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () {
        return ref.refresh(newsListProvider.future);
      },
      child: Center(
          key: Key('news_list_error'),
          child: Container(
              child: Icon(Icons.clear, size: 80, color: Color(0xffd1d4db)),
              width: 160,
              height: 160,
              decoration: BoxDecoration(color: Color(0xffF3F4F6), shape: BoxShape.circle))),
    );
  }
}

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(context, WidgetRef ref) {
    var bottomBar = ref.watch(_currentBottomBarTabProvider);

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
            backgroundColor: ref.watch(theme).tabBackground,
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
