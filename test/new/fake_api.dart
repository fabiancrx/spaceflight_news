import 'dart:convert';
import 'dart:io';

import 'package:spaceflight_news/src/common/api/spaceflight_api.dart';
import 'package:spaceflight_news/src/common/exceptions.dart';
import 'package:spaceflight_news/src/news/new.dart';

class FakeSpaceflight implements SpaceflightApi {
  @override
  Future<New?> article(String id) async {
    if (id != '60a189ddc2ea06001d94fa95') {
      throw ServerException(message: 'The only valid id is 60a189ddc2ea06001d94fa95');
    }
    final file = new File('test/mocks/article.json');
    final json = jsonDecode(await file.readAsString());
    final news = New.fromJson(json);
    return news;
  }

  @override
  Future<List<New>?> articles() async {
    final file = new File('test/mocks/articles.json');
    final json = jsonDecode(await file.readAsString()) as List;
    final news = json.map((e) => New.fromJson(e)).toList(growable: false);
    return news;
  }
}
