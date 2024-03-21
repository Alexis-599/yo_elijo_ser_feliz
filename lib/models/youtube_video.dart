class YouTubeVideo {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final DateTime publishedAt;

  YouTubeVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.publishedAt,
  });

  factory YouTubeVideo.fromJson(Map<String, dynamic> json) {
    return YouTubeVideo(
      id: json['snippet']['resourceId']['videoId'] ?? '',
      title: json['snippet']['title'] ?? '',
      description: json['snippet']['description'] ?? '',
      thumbnailUrl: json['snippet']['thumbnails']['maxres']['url'],
      publishedAt: DateTime.parse(json['snippet']['publishedAt']),
    );
  }

  toJson() {}
}
