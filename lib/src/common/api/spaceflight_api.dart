import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lumberdash/lumberdash.dart';
import 'package:spaceflight_news/src/common/exceptions.dart';
import 'package:spaceflight_news/src/environment.dart';
import 'package:spaceflight_news/src/news/model/new.dart';

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

  static const pageSize = 10;

  Future<Response> _get(Future<Response> request) async {
    try {
      final response = await request;
      return response;
    } on DioError catch (error, st) {
      logError(error, stacktrace: st);
      throw ServerException.fromDioError(error);
    }
  }

  Future<List<New>?> articles({int? limit, int? start, String? searchTerm}) async {
    final uri = _environment.uri.replace(
      path: '${_environment.uri.path}articles',
      queryParameters: <String, Object>{
        if (limit != null) "_limit": '$limit',
        if (start != null) "_start": '$start',
        if (searchTerm != null) "title_contains": '$searchTerm',
        "_limit": '50',
      },
    );
    final response = await _get(_client.getUri(uri));

    if (response.statusCode == 200) {
      final decodedArticles = response.data as List;
      final news = decodedArticles.map((e) => New.fromJson(e as Map<String, dynamic>)).toList(growable: false);

      for (final article in news) {
        _newsCache['${article.id}'] = article;
      }
      return news;
    }
  }

  Future<New?> readArticle(String id) async {
    if (_newsCache.containsKey(id)) {
      return _newsCache[id];
    }

    final response = await _get(_client.get('articles/$id'));
    if (response.statusCode == 200) {
      final decodedArticle = response.data;
      final article = New.fromJson(decodedArticle as Map<String, dynamic>);
      return article;
    }
  }
}

class FakeSpaceflight extends SpaceflightApi {
  FakeSpaceflight() : super(environment: Environment.testing());

  @override
  Future<New> readArticle(String id) async {
    return Future.value(New.fromJson(jsonDecode(singleNews) as Map<String, dynamic>));
  }

  Future<List<New>> _search(String searchTerm) async {
    final allNews = await articles();
    return allNews.where((element) => element.title.contains(searchTerm)).toList();
  }

  @override
  Future<List<New>> articles({int? limit, int? start, String? searchTerm}) async {
    if (searchTerm != null) return _search(searchTerm);
    final decodedArticles = jsonDecode(newsJson) as List;
    final news = decodedArticles.map<New>((e) => New.fromJson(e as Map<String, dynamic>)).toList(growable: false);
    return news;
  }

  final newsJson = """
[
  {
    "id": "60a189ddc2ea06001d94fa95",
    "title": "SpaceX on track to launch eight Falcon 9 rockets in six weeks",
    "url": "https://www.teslarati.com/spacex-eight-falcon-9-launches-six-weeks-2021/",
    "imageUrl": "https://www.teslarati.com/wp-content/uploads/2021/05/Starlink-26-Falcon-9-B1058-39A-051521-Richard-Angle-1-crop-c.jpg",
    "newsSite": "Teslarati",
    "summary": "After yesterday???s successful Starlink-26 launch, SpaceX is now more than half of the way to completing eight orbital Falcon 9 launches in...",
    "publishedAt": "2021-05-16T21:08:38.000Z",
    "updatedAt": "2021-05-17T05:21:56.744Z",
    "featured": false,
    "launches": [
      {
        "id": "fb25ecf0-fb51-4b5e-b678-105f6ba4c06e",
        "provider": "Launch Library 2"
      }
    ],
    "events": []
  },
  {
    "id": "60a174abc2ea06001d94fa94",
    "title": "Starship SN15 patiently awaits a decision ??? The Road to Orbit",
    "url": "https://www.nasaspaceflight.com/2021/05/starship-sn15-reflight-road-orbit/",
    "imageUrl": "https://www.nasaspaceflight.com/wp-content/uploads/2021/05/NSF-2021-05-16-19-28-29-341.jpg",
    "newsSite": "NASA Spaceflight",
    "summary": "Following its successful launch and landing, Starship SN15 has been placed back onto a launch mount for inspections and a potential re-flight. The upcoming test schedule will be focused on providing a green light for an orbital attempt that has already been filed with the FCC (Federal Communications Commission).",
    "publishedAt": "2021-05-16T19:34:26.000Z",
    "updatedAt": "2021-05-17T05:21:22.961Z",
    "featured": true,
    "launches": [
      {
        "id": "e32d375f-0d6e-4e54-b4f2-2b49db657fca",
        "provider": "Launch Library 2"
      }
    ],
    "events": []
  },
  {
    "id": "60a07c35c2ea06001d94fa91",
    "title": "SpaceX ramps up launch rate with fifth Falcon 9 mission in three weeks",
    "url": "https://spaceflightnow.com/2021/05/16/spacex-ramps-up-launch-rate-fifth-falcon-9-mission-in-three-weeks/",
    "imageUrl": "https://mk0spaceflightnoa02a.kinstacdn.com/wp-content/uploads/2021/05/starlink26_1.jpg",
    "newsSite": "Spaceflight Now",
    "summary": "SpaceX???s fifth Falcon 9 launch in a little more than three weeks delivered 52 more Starlink internet satellites and two small hitchhiker payloads to orbit after a booming blastoff from the Kennedy Space Center in Florida on Saturday evening.",
    "publishedAt": "2021-05-16T12:18:13.000Z",
    "updatedAt": "2021-05-16T12:18:13.750Z",
    "featured": false,
    "launches": [
      {
        "id": "c32d1f5e-2dd9-4b55-ac8b-3eb8c4a4e955",
        "provider": "Launch Library 2"
      }
    ],
    "events": []
  },
  {
    "id": "60a1ee89c2ea06001d94fa96",
    "title": "Photos: Atlas 5 ready for liftoff with SBIRS GEO 5",
    "url": "https://spaceflightnow.com/2021/05/16/photos-atlas-5-ready-for-liftoff-with-sbirs-geo-5/",
    "imageUrl": "https://mk0spaceflightnoa02a.kinstacdn.com/wp-content/themes/mh-magazine/images/placeholder-medium.png",
    "newsSite": "Spaceflight Now",
    "summary": "These photos show a 194-foot-tall United Launch Alliance Atlas 5 rocket standing on pad 41 at Cape Canaveral Space Force Station in advance of a planned launch with the U.S. Space Force???s fifth SBIRS missile warning satellite.",
    "publishedAt": "2021-05-16T04:18:17.000Z",
    "updatedAt": "2021-05-17T05:20:55.116Z",
    "featured": false,
    "launches": [
      {
        "id": "137a0935-a14f-4690-9ce2-02c8c2ebd1c5",
        "provider": "Launch Library 2"
      }
    ],
    "events": []
  },
  {
    "id": "60a0338dc2ea06001d94fa8d",
    "title": "Photos: Falcon 9 stands ready for weekend launch",
    "url": "https://spaceflightnow.com/2021/05/15/photos-falcon-9-stands-ready-for-weekend-launch/",
    "imageUrl": "https://mk0spaceflightnoa02a.kinstacdn.com/wp-content/uploads/2021/05/f9_starlink26_pre4.jpg",
    "newsSite": "Spaceflight Now",
    "summary": "A SpaceX Falcon 9 rocket stood atop historic launch pad 39A Saturday afternoon as teams counted down to liftoff with 52 more Starlink internet satellites  and two hitchhiker payloads.",
    "publishedAt": "2021-05-15T20:48:13.000Z",
    "updatedAt": "2021-05-15T21:07:33.741Z",
    "featured": false,
    "launches": [
      {
        "id": "c32d1f5e-2dd9-4b55-ac8b-3eb8c4a4e955",
        "provider": "Launch Library 2"
      }
    ],
    "events": []
  },
  {
    "id": "60a00bb9c2ea06001d94fa8c",
    "title": "U.S. senator: China landing on Mars a reminder ???we don???t own space anymore???",
    "url": "https://spacenews.com/u-s-senator-china-landing-on-mars-a-reminder-we-dont-own-space-anymore/",
    "imageUrl": "https://spacenews.com/wp-content/uploads/2021/05/1128686.jpg",
    "newsSite": "SpaceNews",
    "summary": "Sen. Angus King (I-Maine) said China's success landing a rover on Mars puts to rest any doubt that the nation is a rising space power that will challenge the United States.",
    "publishedAt": "2021-05-15T17:58:17.000Z",
    "updatedAt": "2021-05-15T21:07:45.303Z",
    "featured": false,
    "launches": [
      {
        "id": "485b9786-5bec-4dd4-ac82-69d1fd702047",
        "provider": "Launch Library 2"
      }
    ],
    "events": [
      {
        "id": "126",
        "provider": "Launch Library 2"
      }
    ]
  },
  {
    "id": "60a00967c2ea06001d94fa8b",
    "title": "SpaceX launches Starlink rideshare mission as constellation deployment milestone nears",
    "url": "https://www.nasaspaceflight.com/2021/05/spacex-starlink-rideshare-milestone-nears/",
    "imageUrl": "https://www.nasaspaceflight.com/wp-content/uploads/2021/05/E1dzbVWXEAE3QgE.jpg",
    "newsSite": "NASA Spaceflight",
    "summary": "SpaceX launched its third Starlink mission in just 11 days on the v1.0 L26 flight. The mission brings the total number of operational Starlink v1.0 satellites launched to near 1,567 ??? just shy of the 1,584 needed to declare all of the first shell of Starlinks launched.",
    "publishedAt": "2021-05-15T17:45:38.000Z",
    "updatedAt": "2021-05-16T00:08:24.651Z",
    "featured": false,
    "launches": [
      {
        "id": "c32d1f5e-2dd9-4b55-ac8b-3eb8c4a4e955",
        "provider": "Launch Library 2"
      }
    ],
    "events": []
  },
  {
    "id": "609ff445c2ea06001d94fa8a",
    "title": "Two BlackSky satellites lost on Rocket Lab launch failure",
    "url": "https://spaceflightnow.com/2021/05/15/two-blacksky-satellites-lost-on-rocket-lab-launch-failure/",
    "imageUrl": "https://mk0spaceflightnoa02a.kinstacdn.com/wp-content/uploads/2021/05/rl20_plume.jpg",
    "newsSite": "Spaceflight Now",
    "summary": "A Rocket Lab Electron launcher malfunctioned about two-and-a-half minutes after liftoff from New Zealand Saturday, destroying two BlackSky optical Earth-imaging satellites in the launch company???s second failed flight in less than a year.",
    "publishedAt": "2021-05-15T16:18:13.000Z",
    "updatedAt": "2021-05-15T17:15:58.810Z",
    "featured": false,
    "launches": [
      {
        "id": "0c2347a5-73f1-462c-91f7-8aa8b917ab0d",
        "provider": "Launch Library 2"
      }
    ],
    "events": []
  },
  {
    "id": "60a11b95c2ea06001d94fa93",
    "title": "Billion-dollar missile defense satellite ready for launch Monday in Florida",
    "url": "https://spaceflightnow.com/2021/05/15/billion-dollar-missile-defense-satellite-ready-for-launch-monday-at-cape-canaveral/",
    "imageUrl": "https://mk0spaceflightnoa02a.kinstacdn.com/wp-content/uploads/2021/05/sbirsgeo5_solararray.jpg",
    "newsSite": "Spaceflight Now",
    "summary": "A sophisticated combat-ready U.S. military missile warning satellite moved to its launch pad at Cape Canaveral Space Force Station Saturday on top of a United Launch Alliance Atlas 5 rocket, ready for liftoff Monday afternoon.",
    "publishedAt": "2021-05-15T13:18:13.000Z",
    "updatedAt": "2021-05-16T17:43:25.786Z",
    "featured": false,
    "launches": [
      {
        "id": "137a0935-a14f-4690-9ce2-02c8c2ebd1c5",
        "provider": "Launch Library 2"
      }
    ],
    "events": []
  },
  {
    "id": "609fc564c2ea06001d94fa89",
    "title": "Two hitchhiker smallsats to accompany SpaceX???s next Starlink mission into orbit",
    "url": "https://spaceflightnow.com/2021/05/15/two-hitchhiker-smallsats-to-accompany-spacexs-next-starlink-mission-into-orbit/",
    "imageUrl": "https://mk0spaceflightnoa02a.kinstacdn.com/wp-content/uploads/2020/08/sequoia_sat.jpg",
    "newsSite": "Spaceflight Now",
    "summary": "An innovative commercial Capella radar observation spacecraft with night vision and a small payload from the California-based smallest manufacturer Tyvak are set to rocket into orbit from Florida???s Space Coast Saturday with 52 more Starlink internet satellites on a SpaceX Falcon 9 rocket.",
    "publishedAt": "2021-05-15T12:58:12.000Z",
    "updatedAt": "2021-05-15T17:21:54.100Z",
    "featured": false,
    "launches": [
      {
        "id": "c32d1f5e-2dd9-4b55-ac8b-3eb8c4a4e955",
        "provider": "Launch Library 2"
      }
    ],
    "events": []
  }
]
""";
  final singleNews = """
  {
  "title": "SpaceX on track to launch eight Falcon 9 rockets in six weeks",
  "url": "https://www.teslarati.com/spacex-eight-falcon-9-launches-six-weeks-2021/",
  "imageUrl": "https://www.teslarati.com/wp-content/uploads/2021/05/Starlink-26-Falcon-9-B1058-39A-051521-Richard-Angle-1-crop-c.jpg",
  "newsSite": "Teslarati",
  "summary": "After yesterday???s successful Starlink-26 launch, SpaceX is now more than half of the way to completing eight orbital Falcon 9 launches in...",
  "publishedAt": "2021-05-16T21:08:38.000Z",
  "updatedAt": "2021-05-17T05:21:56.744Z",
  "featured": false,
  "launches": [
    {
      "id": "fb25ecf0-fb51-4b5e-b678-105f6ba4c06e",
      "provider": "Launch Library 2"
    }
  ],
  "events": []
}
  """;
}
