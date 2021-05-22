import 'package:flutter/material.dart';
import 'package:spaceflight_news/resources/resources.dart';
import 'package:spaceflight_news/src/common/extensions.dart';
import 'package:spaceflight_news/src/common/theme.dart';
import 'package:spaceflight_news/src/common/widget/no_data.dart';

class NoNews extends StatelessWidget {
  final bool isLoading;

  const NoNews({Key? key, this.isLoading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NoData(isLoading: isLoading, image: AssetImage(AssetIcon.notFoundNew), text: context.l10n.noNewsYet);
  }
}

class NoSearchResults extends StatelessWidget {
  final bool isLoading;

  const NoSearchResults({Key? key, this.isLoading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NoData(
      image: AssetImage(AssetIcon.notFoundSearch),
      isLoading: isLoading,
      text: context.l10n.searchNoResults,
      child: Text(
        context.l10n.searchAnotherWord,
        style: TextStyles.body2.copyWith(color: OnePlaceColor.gray800),
      ),
    );
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
