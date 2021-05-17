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

  Future<List<New>?> articles() async {
    try {
      final response = await _client.get('articles');
      if (response.statusCode == 200) {
        final decodedArticles = response.data as List;
        final news = decodedArticles.map((e) => New.fromJson(e)).toList(growable: false);

        for (final article in news) {
          _newsCache[article.id] = article;
        }
        return news;
      }
    } on DioError catch (error, stacktrace) {
      // TODO logging
      throw ServerException.fromDioError(error);
    } on Exception catch (error, stacktrace) {
      throw ServerException(message: 'Error connecting to server', stackTrace: stacktrace);
    }
  }

  Future<New?> article(String id) async {
    try {
      if (_newsCache.containsKey(id)) {
        return _newsCache[id];
      }

      final response = await _client.get('articles/$id');
      if (response.statusCode == 200) {
        final decodedArticle = response.data;
        final article = New.fromJson(decodedArticle);
        return article;
      }
    } on DioError catch (error, stacktrace) {
      // TODO Refactor error handling to interceptor
      throw ServerException.fromDioError(error);
    } on Exception catch (error, stacktrace) {
      throw ServerException(message: 'Error connecting to server', stackTrace: stacktrace);
    }
  }
}
