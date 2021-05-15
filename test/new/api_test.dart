import 'package:flutter_test/flutter_test.dart';
import 'package:spaceflight_news/src/api/spaceflight_api.dart';
import 'package:spaceflight_news/src/environment.dart';
import 'package:spaceflight_news/src/models/new.dart';

void main() {
  late final SpaceflightApi spaceflightApi;
  setUp(() {
    spaceflightApi = SpaceflightApi(environment: Environment.testing());
  });
  group('GET news form API ', () {
    test('News are correctly fetched and deserialized', () async {
      var articles = await spaceflightApi.articles();

      expect(articles, isA<List<New>?>());
      expect(articles?.length, greaterThan(0));

      if (articles != null) {
        for (var news in articles) {
          expect(news, isA<New>());
        }
      }
    });
  });
}
