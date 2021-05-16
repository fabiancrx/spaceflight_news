import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spaceflight_news/src/api/spaceflight_api.dart';
import 'package:spaceflight_news/src/environment.dart';
import 'package:spaceflight_news/src/models/new.dart';
import 'package:spaceflight_news/src/shared/extensions.dart';
import 'package:spaceflight_news/src/widget/no_data.dart';

import 'resources/resources.dart';
import 'src/news/news_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        onGenerateTitle: (BuildContext context) => context.l10n.appTitle,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: NewsFeed());
  }
}

class NewsFeed extends StatefulWidget {
  const NewsFeed({Key? key}) : super(key: key);

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  late Future<List<New>?> _newsFuture =
      SpaceflightApi(environment: Environment.production()).articles();
  var _bottomBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        currentIndex: _bottomBarIndex,
        onTap: (i) {
          setState(() {
            _bottomBarIndex = i;
          });
        },
      ),
      appBar: AppBar(
        title: Text(context.l10n.feed),
        centerTitle: false,
        elevation: 0,
        actions: [Image.asset(AssetIcon.search)],
      ),
      body: FutureBuilder<List<New>?>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var news = snapshot.data;
            if (news == null || news.isEmpty) {
              return _noNews(context);
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  NewsHeader(),
                  for (var i = 0; i < news.length; i++) ...[
                    if (i > 0) const SizedBox(height: 16),
                    NewsCard(news: news[i]),
                  ],
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          return _noNews(context);
        },
      ),
    );
  }
}

Widget _noNews(BuildContext context) =>
    NoData(image: AssetImage(AssetIcon.news), message: context.l10n.noNewsYet);

class NewsHeader extends StatelessWidget {
  const NewsHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            height: 20,
            foregroundDecoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)))),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(context.l10n.newsFeed),
        )
      ],
    );
  }
}
