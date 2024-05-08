class Movie {
  final int rank;
  final String title;
  final String description;
  final String image;
  final List<String> genre;
  final double rating;

  Movie({
    required this.rank,
    required this.title,
    required this.description,
    required this.image,
    required this.genre,
    required this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      rank: json['rank'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      genre: List<String>.from(json['genre'] ?? []),
      rating: double.tryParse(json['rating'] ?? '0.0') ?? 0.0,
    );
  }
}
