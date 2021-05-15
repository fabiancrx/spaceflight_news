import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spaceflight_news/src/api/spaceflight_api.dart';
import 'package:spaceflight_news/src/environment.dart';
import 'package:spaceflight_news/src/models/new.dart';
import 'package:spaceflight_news/src/shared/extensions.dart';
import 'package:spaceflight_news/src/widget/no_data.dart';

import 'resources/resources.dart';

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
      SpaceflightApi(environment: Environment.testing()).articles();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<New>?>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var news = snapshot.data;
            if (news == null || news.isEmpty) {
              return _noNews(context);
            }
            return ListView.builder(
                itemCount: news.length,
                itemBuilder: (context, i) {
                  return NewsItem(news: news[i]);
                });
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

class NewsItem extends StatelessWidget {
  final New news;

  const NewsItem({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(news.title),
      subtitle: Text(news.publishedAt.formatYmmmmd()),
      leading: Image.network(news.imageUrl),
    );
  }
}
