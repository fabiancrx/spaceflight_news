import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaceflight_news/main.dart';
import 'package:spaceflight_news/resources/resources.dart';
import 'package:spaceflight_news/src/common/extensions.dart';
import 'package:spaceflight_news/src/common/theme.dart';
import 'package:spaceflight_news/src/news/new.dart';
const favoriteCardHeight=.42;
const newsCardHeight=.39;
class NewsCard extends StatelessWidget {
  final New news;

  const NewsCard({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        var screenSize = MediaQuery.of(context).size;
        var boxConstraints = constraints.constrainDimensions(double.infinity, screenSize.height * .39);
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(news.title,style: TextStyles.caption1),
                        SizedBox(height: 12),
                        DateRow(news: news),
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
    Widget favorite =
        news.isFavorite ? Image.asset(AssetIcon.favoriteSelected) : Image.asset(AssetIcon.favoriteOutlineGray);

    return Row(
      children: [
        Image.asset(AssetIcon.calendarGray),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 24),
          child: Text(news.publishedAt.formatYmmmmd(),style: TextStyles.body2),
        ),
        InkWell(
          onTap: () {
            context.read(feedViewModel).toggleFavorite(news);
          },
          child: favorite,
        ),
      ],
    );
  }
}
