import 'package:dio/dio.dart';
import 'package:spaceflight_news/src/core/exceptions.dart';
import 'package:spaceflight_news/src/environment.dart';
import 'package:spaceflight_news/src/models/new.dart';

class SpaceflightApi {
  final Environment _environment;
  final Dio _client;

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
        final news =
            decodedArticles.map((e) => New.fromJson(e)).toList(growable: false);
        return news;
      }
    } on DioError catch (error, stacktrace) {
      // TODO logging
      throw ServerException.fromDioError(error);
    } on Exception catch (error, stacktrace) {
      throw ServerException(
          message: 'Error connecting to server', stackTrace: stacktrace);
    }
  }
}
