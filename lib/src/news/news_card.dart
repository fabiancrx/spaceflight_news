import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:spaceflight_news/resources/resources.dart';
import 'package:spaceflight_news/src/models/new.dart';
import 'package:spaceflight_news/src/shared/extensions.dart';

class NewsList extends StatelessWidget {
  final List<New> news;

  const NewsList({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(shrinkWrap: true,
          itemCount: news.length,
          itemBuilder: (context, i) {
            return NewsCard(news: news[i]);
          },
          separatorBuilder: (_, i) => SizedBox(height: 16)),
    );
  }
}

class NewsCard extends StatelessWidget {
  final New news;

  const NewsCard({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        var screenSize = MediaQuery.of(context).size;
        var boxConstraints = constraints.constrainDimensions(
            double.infinity, screenSize.height * .33);
        return ConstrainedBox(
          constraints: BoxConstraints.loose(boxConstraints),
          child: Stack(
            children: [
              Container(
                foregroundDecoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(news.imageUrl),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                width: constraints.maxWidth,
                child: Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AutoSizeText(news.title),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: DateRow(news: news),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DateRow extends StatelessWidget {
  final New news;

  const DateRow({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(AssetIcon.calendarGray),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 24),
          child: Text(news.publishedAt.formatYmmmmd()),
        ),
        Image.asset(AssetIcon.favoriteSelected),
      ],
    );
  }
}
