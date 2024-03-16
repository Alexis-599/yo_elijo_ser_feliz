class YouTubeVideo {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;

  YouTubeVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
  });

  factory YouTubeVideo.fromJson(Map<String, dynamic> json) {
    return YouTubeVideo(
      id: json['snippet']['resourceId']['videoId'] ?? '',
      title: json['snippet']['title'] ?? '',
      description: json['snippet']['description'] ?? '',
      thumbnailUrl: json['snippet']['thumbnails']['high']['url'],
    );
  }

  toJson() {}
}
