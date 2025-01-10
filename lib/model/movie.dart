class Movie {
  final int id;
  final String name;
  final String summary;
  final String? imageUrl;
  final String? status;
  final List<String>? genres;
  final double? rating;
  final String? href;
  final String type;
  final String language;
  final int? runtime;
  final String? premiered;
  final String? ended;
  final String? officialSite;
  final Schedule? schedule;
  final Network? network;
  final String? imdbId;

  Movie({
    required this.id,
    required this.name,
    required this.summary,
    this.imageUrl,
    this.status,
    this.genres,
    this.rating,
    this.href,
    required this.type,
    required this.language,
    this.runtime,
    this.premiered,
    this.ended,
    this.officialSite,
    this.schedule,
    this.network,
    this.imdbId,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final show = json['show'] ?? json;
    return Movie(
      id: show['id'],
      name: show['name'],
      summary: show['summary'] ?? 'No summary available',
      imageUrl: show['image']?['original'],
      status: show['status'],
      genres: List<String>.from(show['genres'] ?? []),
      rating: show['rating']?['average']?.toDouble(),
      href: show['_links']['self']['href'],
      type: show['type'] ?? 'Unknown',
      language: show['language'] ?? 'Unknown',
      runtime: show['runtime'],
      premiered: show['premiered'],
      ended: show['ended'],
      officialSite: show['officialSite'],
      schedule:
          show['schedule'] != null ? Schedule.fromJson(show['schedule']) : null,
      network:
          show['network'] != null ? Network.fromJson(show['network']) : null,
      imdbId: show['externals']?['imdb'],
    );
  }
}

class Schedule {
  final String? time;
  final List<String> days;

  Schedule({this.time, required this.days});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      time: json['time'],
      days: List<String>.from(json['days'] ?? []),
    );
  }
}

class Network {
  final int id;
  final String name;
  final String countryName;
  final String countryCode;

  Network({
    required this.id,
    required this.name,
    required this.countryName,
    required this.countryCode,
  });

  factory Network.fromJson(Map<String, dynamic> json) {
    return Network(
      id: json['id'],
      name: json['name'],
      countryName: json['country']?['name'] ?? 'Unknown',
      countryCode: json['country']?['code'] ?? 'XX',
    );
  }
}
