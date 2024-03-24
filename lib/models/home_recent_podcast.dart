import 'package:podcasts_ruben/models/playlist_model.dart';
import 'package:podcasts_ruben/models/youtube_video.dart';

class CompletePlaylistModel {
  final List<YouTubeVideo> videos;
  final PlayListModel playListModel;

  CompletePlaylistModel({
    required this.videos,
    required this.playListModel,
  });
}
