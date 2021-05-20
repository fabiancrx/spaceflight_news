import 'package:flutter_test/flutter_test.dart';
import 'package:spaceflight_news/src/common/api/spaceflight_api.dart';
import 'package:spaceflight_news/src/common/exceptions.dart';
import 'package:spaceflight_news/src/environment.dart';
import 'package:spaceflight_news/src/news/new.dart';

import 'fake_api.dart';

const _sampleArticleId = '60a189ddc2ea06001d94fa95';

void main() {
  late SpaceflightApi spaceflightApi;
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
      var article = await spaceflightApi.article(_sampleArticleId);

      expect(article, isA<New?>());
      expect(article?.newsSite, 'Teslarati');

      expect(() async => await spaceflightApi.article('foo'), throwsA(isA<ServerException>()));
    });
  });
}
