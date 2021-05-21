import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaceflight_news/main.dart';
import 'package:spaceflight_news/resources/resources.dart';
import 'package:spaceflight_news/src/common/extensions.dart';
import 'package:spaceflight_news/src/common/theme.dart';
import 'package:spaceflight_news/src/common/widget/placeholder_image.dart';
import 'package:spaceflight_news/src/news/model/new.dart';

const favoriteCardHeight = .42;
const newsCardHeight = .39;

class NewsCard extends StatelessWidget {
  final New news;

  /// Compact card that roughly occupies 40% of the screen height to display a [New]
  const NewsCard({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        var screenSize = MediaQuery.of(context).size;
        var boxConstraints = constraints.constrainDimensions(double.infinity, screenSize.height * newsCardHeight);
        return InkWell(
          key: Key(news.id),
          onTap: () => onCardTapped(context),
          child: ConstrainedBox(
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(news.title, style: TextStyles.caption1),
                          SizedBox(height: 12),
                          DateRow(news: news),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void onCardTapped(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return NewsDetail(news: news);
    }));
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
          child: Text(news.publishedAt.formatYmmmmd(), style: TextStyles.body2),
        ),
        InkWell(
          onTap: () {
            context.read(feedViewModel.notifier).toggleFavorite(news);
          },
          child: favorite,
        ),
      ],
    );
  }
}

class NewsDetail extends StatelessWidget {
  final New news;

  const NewsDetail({Key? key, required this.news}) : super(key: key);
  static const double _appBarSize = 64;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(NewsDetail._appBarSize),
            child: AppBar(
              title: Text(context.l10n.article, style: TextStyles.h1),
              centerTitle: false,
              elevation: 0,
              backgroundColor: OnePlaceColor.gray900,
              backwardsCompatibility: false,
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Theme.of(context).backgroundColor,
                  statusBarIconBrightness: Theme.of(context).brightness.invert()),
            )),
        body: Stack(
          children: [
            Positioned(
              child: PlaceHolderNetworkImage(
                news.imageUrl,
                fit: BoxFit.cover,
                height: size.height * .275,
              ),
              top: 0,
              left: 0,
              right: 0,
            ),
            Positioned(
                top: size.height * .26,
                // width: size.width,
                bottom: 0.0,
                right: 0.0,
                left: 0.0,
                child: Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Text(news.title, style: TextStyles.caption1),
                        SizedBox(height: 16),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.only(top: 12, bottom: 9),
                          child: Row(
                            children: [
                              Text(context.l10n.by, style: TextStyles.body1),
                              SizedBox(width: 8),
                              Text(news.newsSite, style: TextStyles.caption1)
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        DateRow(news: news),
                        SizedBox(height: 44),
                        Text(
                          news.summary,
                          style: TextStyles.body1,
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ));
  }
}
