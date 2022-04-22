/// Class in which the configuration settings of the app are stored.
// It is used for encapsulating and injecting different configurations to the app at runtime
class Environment {
  final Uri uri;
  final bool production;

  const Environment({required this.production, required this.uri});

  String get url => uri.toString();

  factory Environment.production() =>
      Environment(production: true, uri: Uri(scheme: 'https', host: 'api.spaceflightnewsapi.net', path: '/v3/'));

  factory Environment.testing() =>
      Environment(production: false, uri: Uri(scheme: 'https', host: 'test.spaceflightnewsapi.net', path: '/v3/'));
}
