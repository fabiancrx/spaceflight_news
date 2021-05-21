import 'package:hive/hive.dart';

import 'model/new.dart';

class NewsRepository {
  final Box<New> _box;

  NewsRepository(this._box);

  Future<List<New>?> browse() async {
    var favoriteNews=_box.values.toList();
    favoriteNews.forEach(print);
    return favoriteNews;
  }

  Future<void> insert(New _new) async {
    // Only favorites will be saved
    _new.isFavorite = true;
    print('About to insert $_new');
    await _box.put(_new.id, _new);
  }

// remove favorite new
  Future<void> delete(String id) async {
    print('About to delete $id');

    await _box.delete(id);
  }
}
