class Movie {
  final int id;
  final String name;
  final String summary;
  final String? imageUrl;
  final String? status;
  final List<String>? genres;
  final double? rating;
  final String? href;
  Movie({
    required this.id,
    required this.name,
    required this.summary,
    this.imageUrl,
    this.status,
    this.genres,
    this.rating,
    this.href,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final show = json['show'];
    return Movie(
      id: show['id'],
      name: show['name'],
      summary: show['summary'] ?? 'No summary available',
      imageUrl: show['image']?['original'],
      status: show['status'],
      genres: List<String>.from(show['genres'] ?? []),
      rating: show['rating']?['average']?.toDouble(),
      href: show['_links']['self']['href'],
    );
  }
}
