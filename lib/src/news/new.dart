class New {
  final String id;
  final bool featured;
  final String title;
  final String url;
  final String imageUrl;
  final String newsSite;
  final String summary;
  final DateTime publishedAt;
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
        id: json["id"]??'',
        featured: json["featured"],
        title: json["title"],
        url: json["url"],
        imageUrl: json["imageUrl"],
        newsSite: json["newsSite"],
        summary: json["summary"],
        publishedAt: DateTime.parse(json["publishedAt"]),
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
      };
}
New markAsFavorite(New news) {
  news.isFavorite = true;
  return news;
}
New toggleFavorite(New news) {
  news.isFavorite = !news.isFavorite;
  return news;
}