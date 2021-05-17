/// Class in which the configuration settings of the app are stored.
// It is used for encapsulating and injecting different configurations to the app at runtime
class Environment {
  final String url;
  final bool production;

  const Environment({required this.url, required this.production});

  factory Environment.production() => Environment(
        url: 'https://spaceflightnewsapi.net/api/v2/',
        production: true,
      );

  factory Environment.testing() => Environment(
        url: 'https://test.spaceflightnewsapi.net/api/v2/',
        production: false,
      );
}
