import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:spaceflight_news/main.dart';
import 'package:spaceflight_news/src/common/api/spaceflight_api.dart';
import 'package:spaceflight_news/src/news/feed_page.dart';
import 'package:spaceflight_news/src/news/model/new.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spaceflight_news/src/news/viewmodel/feed_viewmodel.dart';

void main() {
  setUp(() {});
  group('News Model', () {
    test('News Model is correctly serialized and deserialized', () {
      var testNew = New.fromJson(jsonDecode(_newsJson) as Map<String, dynamic>);

      expect(testNew, isA<New>());
      expect(testNew.toJson()..remove('favorite'), jsonDecode(_newsJson),
          reason: "Check the Map<String,dynamic> of the de-serialized `New` is equals to the deserialized json");
    });
  });

  testWidgets('Feed page gets built on App start and displays [NoData] screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          persistence.overrideWithValue(MockBox<New>()),
          api.overrideWithValue(FakeSpaceflight()), //Uncomment this line to mock the API
        ],
        child: TestApp(),
      ),
    );

    expect(find.byKey(Key('feed_page')), findsOneWidget);
    expect(find.byKey(Key('no_data')), findsOneWidget);
  });
  testWidgets('When search is active the searchbar is displayed with no articles', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          persistence.overrideWithValue(MockBox<New>()),
          api.overrideWithValue(FakeSpaceflight()), //Uncomment this line to mock the API
          searchBarProvider.overrideWithValue(SearchBarState(isActive: true))
        ],
        child: TestApp(),
      ),
    );

    expect(find.byKey(Key('searchbar')), findsOneWidget);
    expect(find.byKey(Key('no_data')), findsOneWidget);
  });
}

class MockBox<T> extends Fake implements Box<T> {
  Iterable<T> get values => [];
}

//  https://spaceflightnewsapi.net/api/v2/articles
const _newsJson = """
  {
    "id": "string",
    "featured": false,
    "title": "string",
    "url": "string",
    "imageUrl": "string",
    "newsSite": "string",
    "summary": "string",
    "publishedAt": "2020-08-04T10:00:00.000Z"
  }
""";

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: NewsFeed(),
    );
  }
}
