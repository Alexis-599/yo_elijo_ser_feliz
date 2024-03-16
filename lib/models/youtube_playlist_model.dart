class YouTubePlaylist {
  final String id;
  final String title;
  final String thumbnailUrl;
  final int itemCount;

  YouTubePlaylist({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.itemCount,
  });

  factory YouTubePlaylist.fromJson(Map<String, dynamic> json) {
    return YouTubePlaylist(
      id: json['id'],
      title: json['snippet']['title'],
      thumbnailUrl: json['snippet']['thumbnails']['maxres']['url'],
      itemCount: json['contentDetails']['itemCount'],
    );
  }
}
