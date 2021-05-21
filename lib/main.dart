import 'package:emoji_lumberdash/emoji_lumberdash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lumberdash/lumberdash.dart';
import 'package:spaceflight_news/src/common/api/spaceflight_api.dart';
import 'package:spaceflight_news/src/common/extensions.dart';
import 'package:spaceflight_news/src/common/theme.dart';
import 'package:spaceflight_news/src/environment.dart';
import 'package:spaceflight_news/src/news/favorites_service.dart';
import 'package:spaceflight_news/src/news/feed_page.dart';
import 'package:spaceflight_news/src/news/model/new.dart';
import 'package:spaceflight_news/src/news/news_repository.dart';
import 'package:spaceflight_news/src/news/viewmodel/feed_viewmodel.dart';

/// How to override
/// ```
///     ProviderScope(
///       overrides: [
///         persistence.overrideWithValue(_newValue),
///      ],
///  ```
final persistence = Provider<Box<New>>((ref) {
  throw UnimplementedError("This provider is meant to be overriden by a providerScope "
      "WHY: to provide a box for persistence synchronously");
});

var environment = Provider((_) => Environment.production());
var newsRepository = Provider((ref) => NewsRepository(ref.watch(persistence)));
var api = Provider<SpaceflightApi>((ref) => SpaceflightApi(environment: ref.watch(environment)));
var favoritesService = Provider((ref) => FavoritesService(ref.watch(newsRepository)));
var feedViewModel = ChangeNotifierProvider(
    (ref) => FeedViewModel(spaceflightApi: ref.watch(api), favoritesService: ref.watch(favoritesService)));
var theme = Provider((_) => AppTheme(isDark: false));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure logging client
  putLumberdashToWork(withClients: [if (kDebugMode) EmojiLumberdash(printTime: true)]);

  Hive.registerAdapter(NewAdapter());

  await Hive.initFlutter();
  var box = await Hive.openBox<New>('spaceflight');

  runApp(ProviderScope(
    overrides: [
      // api.overrideWithValue(FakeSpaceflight()),//Uncomment this line to mock the API
      persistence.overrideWithValue(box),
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
