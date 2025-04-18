class ShowDetails {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final String? backdropPath;
  final double voteAverage;
  final List<Genre> genres;
  final String tagline;

  ShowDetails({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.genres,
    required this.tagline,
  });

  factory ShowDetails.fromJson(Map<String, dynamic> json) {
    return ShowDetails(
      id: json['id'],
      // name: json['name'],
      name: json['original_name'] ?? json['original_title'] ?? '',
      overview: json['overview'],
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] as num).toDouble(),
      genres: (json['genres'] as List<dynamic>).map((e) => Genre.fromJson(e)).toList(),
      tagline: json['tagline'] ?? "",
    );
  }
}

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(id: json['id'], name: json['name']);
  }
}
