import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcasts_ruben/models/playlist_model.dart';
import 'package:podcasts_ruben/models/youtube_video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final List<YouTubeVideo> youtubeVideos;
  final int currentVideoIndex;

  const VideoPlayerScreen({
    super.key,
    required this.youtubeVideos,
    required this.currentVideoIndex,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController youtubePlayerController;

  late YouTubeVideo youTubeVideo;
  int currentIndex = 0;
  Duration position = Duration.zero;
  bool isPlaying = false;
  Duration buffer = Duration.zero;
  Duration duration = Duration.zero;

  playVideo(index) {
    youTubeVideo = widget.youtubeVideos[index];
    youtubePlayerController = YoutubePlayerController(
      initialVideoId: youTubeVideo.id,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    youtubePlayerController.addListener(() {
      position = youtubePlayerController.value.position;
      duration = youtubePlayerController.value.metaData.duration;
      isPlaying = youtubePlayerController.value.isPlaying;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentVideoIndex;
  }

  Future<PlayListModel> getPlaylist() async {
    return FirebaseFirestore.instance
        .collection('playlists')
        .doc(widget.youtubeVideos[currentIndex].playlistId)
        .get()
        .then((value) => PlayListModel.fromJson(value.data()!));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    playVideo(currentIndex);
    youTubeVideo = widget.youtubeVideos[currentIndex];
  }

  void _playPreviousVideo() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        youTubeVideo = widget.youtubeVideos[currentIndex];
        youtubePlayerController.load(widget.youtubeVideos[currentIndex].id);
      });
    }
  }

  void _playNextVideo() {
    if (currentIndex < widget.youtubeVideos.length - 1) {
      setState(() {
        currentIndex++;
        youTubeVideo = widget.youtubeVideos[currentIndex];
        youtubePlayerController.load(widget.youtubeVideos[currentIndex].id);
      });
    }
  }

  @override
  void dispose() {
    youtubePlayerController.removeListener(() {});
    youtubePlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.blue.shade200,
            Colors.blue.shade800,
          ])),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: YoutubePlayer(
                      controller: youtubePlayerController,
                      showVideoProgressIndicator: true,
                      aspectRatio: 1 / 1,
                      topActions: const [],
                      bottomActions: const [],
                      thumbnail: CachedNetworkImage(
                        imageUrl: youTubeVideo.thumbnailUrl,
                        fit: BoxFit.cover,
                      ),
                      progressIndicatorColor: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    youTubeVideo.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  FutureBuilder<PlayListModel>(
                      future: getPlaylist(),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data != null ? snapshot.data!.title : '---',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 30,
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 5,
                        overlayShape: SliderComponentShape.noThumb,
                        thumbShape: SliderComponentShape.noThumb,
                      ),
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: Slider(
                          thumbColor: Colors.white,
                          activeColor: Colors.white,
                          inactiveColor: Colors.grey.shade600,
                          min: 0.0,
                          max: duration.inMilliseconds.toDouble(),
                          value: position.inMilliseconds.toDouble(),
                          onChanged: (value) async {
                            final p = Duration(milliseconds: value.toInt());
                            youtubePlayerController.seekTo(p);
                          },
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatTime(position),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        formatTime(duration),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => _playPreviousVideo(),
                        iconSize: 60,
                        color: Colors.white,
                        icon: const Icon(Icons.skip_previous_rounded),
                      ),
                      IconButton(
                        onPressed: () {
                          if (isPlaying) {
                            youtubePlayerController.pause();
                            setState(() {});
                          } else {
                            youtubePlayerController.play();
                            setState(() {});
                          }
                        },
                        iconSize: 75,
                        color: Colors.white,
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _playNextVideo(),
                        iconSize: 60,
                        color: Colors.white,
                        icon: const Icon(Icons.skip_next_rounded),
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}

String formatTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));

  return [
    if (duration.inHours > 0) hours,
    minutes,
    seconds,
  ].join(':');
}
