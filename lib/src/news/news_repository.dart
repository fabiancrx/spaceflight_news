import 'package:hive/hive.dart';

import 'model/new.dart';

class NewsRepository {
  final Box<New> _box;

  NewsRepository(this._box);

  Future<List<New>?> browse() async {
    var favoriteNews = _box.values.toList();
    return favoriteNews;
  }

  Future<void> insert(New _new) async {
    // Only favorites will be saved
    _new.isFavorite = true;
    await _box.put(_new.id, _new);
  }

// remove favorite new
  Future<void> delete(int id) async {
    await _box.delete(id);
  }
}
