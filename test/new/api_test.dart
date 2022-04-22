import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:spaceflight_news/src/common/api/spaceflight_api.dart';
import 'package:spaceflight_news/src/news/model/new.dart';

class MockApi extends Mock implements SpaceflightApi {}

class MockDio extends Mock implements Dio {}

void main() {
  late SpaceflightApi spaceflightApi;
  late SpaceflightApi mockApi;
  setUp(() {
    // uncomment for integration testing with external services
    // spaceflightApi = SpaceflightApi(environment: Environment.production());
    spaceflightApi = FakeSpaceflight();
  });
  group('GET news form API ', () {
    test('News Lists are correctly fetched and deserialized', () async {
      var articles = await spaceflightApi.articles();

      expect(articles, isA<List<New>?>());
      expect(articles?.length, greaterThan(0));

      if (articles != null) {
        for (var news in articles) {
          expect(news, isA<New>());
        }
      }
    });
    test('A single new is fetched from the API', () async {
      var article = await spaceflightApi.readArticle('14795');

      expect(article, isA<New?>());
      expect(article?.newsSite, 'Teslarati');
    });
  });
}
