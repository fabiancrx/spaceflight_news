import 'package:dio/dio.dart';
import 'package:spaceflight_news/src/common/exceptions.dart';
import 'package:spaceflight_news/src/environment.dart';
import 'package:spaceflight_news/src/news/new.dart';

class SpaceflightApi {
  final Environment _environment;
  final Dio _client;
  final _newsCache = <String, New>{};

  SpaceflightApi({required Environment environment, Dio? client})
      : this._environment = environment,
        this._client = client ?? Dio() {
    if (client == null) {
      _client.options
        ..connectTimeout = 10000
        ..baseUrl = _environment.url;
    }
  }

  Future<Response> _get(Future<Response> request) async {
    try {
      final response = await request;
      return response;
    } on DioError catch (error) {
      throw ServerException.fromDioError(error);
    }
  }

  Future<List<New>?> articles({int? limit, int? offset}) async {
    StringBuffer baseQuery = StringBuffer('articles');
    if (limit != null) baseQuery.write('$baseQuery?_limit=$limit');
    if (offset != null) baseQuery.write('$baseQuery?_offset=$offset');

    final response = await _get(_client.get(baseQuery.toString()));
    if (response.statusCode == 200) {
      final decodedArticles = response.data as List;
      final news = decodedArticles.map((e) => New.fromJson(e)).toList(growable: false);

      for (final article in news) {
        _newsCache[article.id] = article;
      }
      return news;
    }
  }

  Future<List<New>?> search(String searchTerm) async {
    final response = await _get(_client.get('articles?title_contains=$searchTerm'));
    if (response.statusCode == 200) {
      final decodedArticles = response.data as List;
      final news = decodedArticles.map((e) => New.fromJson(e)).toList(growable: false);

      for (final article in news) {
        _newsCache[article.id] = article;
      }
      return news;
    }
  }

  Future<New?> article(String id) async {
    if (_newsCache.containsKey(id)) {
      return _newsCache[id];
    }

    final response = await _get(_client.get('articles/$id'));
    if (response.statusCode == 200) {
      final decodedArticle = response.data;
      final article = New.fromJson(decodedArticle);
      return article;
    }
  }
}
