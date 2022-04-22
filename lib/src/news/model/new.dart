import 'package:hive/hive.dart';
part 'new.g.dart';

@HiveType(typeId: 1)
class New {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final bool featured;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String url;
  @HiveField(4)
  final String imageUrl;
  @HiveField(5)
  final String newsSite;
  @HiveField(6)
  final String summary;
  @HiveField(7)
  final DateTime publishedAt;
  @HiveField(8)
  bool isFavorite;

  New({
    required this.id,
    required this.featured,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.newsSite,
    required this.summary,
    required this.publishedAt,
    this.isFavorite = false,
  });

  factory New.fromJson(Map<String, dynamic> json) => New(
        id: json["id"] as int,
        featured: json["featured"] as bool? ?? false,
        title: json["title"] as String,
        url: json["url"] as String,
        imageUrl: json["imageUrl"] as String,
        newsSite: json["newsSite"] as String,
        summary: json["summary"] as String,
        isFavorite: json["favorite"] as bool? ?? false,
        publishedAt: DateTime.parse(json["publishedAt"] as String),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "featured": featured,
        "title": title,
        "url": url,
        "imageUrl": imageUrl,
        "newsSite": newsSite,
        "summary": summary,
        "publishedAt": publishedAt.toIso8601String(),
        "favorite": isFavorite
      };

  @override
  String toString() {
    return 'New{title: $title, isFavorite: $isFavorite}';
  }
}

New markAsFavorite(New news) {
  news.isFavorite = true;
  return news;
}

New toggleFavorite(New news) {
  news.isFavorite = !news.isFavorite;
  return news;
}
