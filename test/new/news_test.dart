import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:spaceflight_news/src/news/new.dart';

void main() {
  setUp(() {});
  group('News Model', () {
    test('News Model is correctly serialized and deserialized', () {
      var testNew = New.fromJson(jsonDecode(_newsJson));

      expect(testNew, isA<New>());
      expect(testNew.toJson(), jsonDecode(_newsJson),
          reason:
              "Check the Map<String,dynamic> of the de-serialized `New` is equals to the deserialized json");
    });
  });
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
