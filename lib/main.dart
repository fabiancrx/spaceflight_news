import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spaceflight_news/src/common/api/spaceflight_api.dart';
import 'package:spaceflight_news/src/common/extensions.dart';
import 'package:spaceflight_news/src/common/theme.dart';
import 'package:spaceflight_news/src/environment.dart';
import 'package:spaceflight_news/src/news/favorites_service.dart';
import 'package:spaceflight_news/src/news/feed_page.dart';
import 'package:spaceflight_news/src/news/viewmodel/feed_viewmodel.dart';

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
var theme = Provider((_) => AppTheme(isDark: false));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  var _sharedPreferences = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    overrides: [
      sharedPreferences.overrideWithValue(_sharedPreferences),
    ],
    child: Consumer(
      builder: (_, watch, child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (BuildContext context) => context.l10n.appTitle,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: watch(theme).themeData,
            home: child);
      },
      child: NewsFeed(),
    ),
  ));
}
