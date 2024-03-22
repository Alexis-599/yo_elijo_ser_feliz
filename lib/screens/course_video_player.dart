import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcasts_ruben/models/course_video.dart';
import 'package:video_player/video_player.dart';

class CourseVideoPlayerScreen extends StatefulWidget {
  final List<CourseVideo> courseVideos;
  final int currentVideoIndex;

  const CourseVideoPlayerScreen(
      {super.key, required this.courseVideos, required this.currentVideoIndex});

  @override
  State<CourseVideoPlayerScreen> createState() =>
      _CourseVideoPlayerScreenState();
}

class _CourseVideoPlayerScreenState extends State<CourseVideoPlayerScreen> {
  VideoPlayerController? videoPlayerController;

  // late CourseVideo courseVideo;
  int currentIndex = 0;
  Duration position = Duration.zero;
  bool isPlaying = false;
  Duration duration = Duration.zero;

  playVideo(index) {
    videoPlayerController?.dispose();
    videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.courseVideos[index].link))
      ..initialize().then((value) {
        setState(() {
          if (videoPlayerController!.value.isInitialized) {
            videoPlayerController!.play();
          }
        });
      });
    videoPlayerController!.addListener(() {
      position = videoPlayerController!.value.position;
      duration = videoPlayerController!.value.duration;
      isPlaying = videoPlayerController!.value.isPlaying;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentVideoIndex;
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(''));
    playVideo(currentIndex);
  }

  void _playPreviousVideo() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        playVideo(currentIndex);
      });
    }
  }

  void _playNextVideo() {
    if (currentIndex < widget.courseVideos.length - 1) {
      setState(() {
        currentIndex++;
        playVideo(currentIndex);
      });
    }
  }

  @override
  void dispose() {
    videoPlayerController?.removeListener(() {});
    videoPlayerController?.dispose();
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
              child: ListView(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 400,
                    width: double.infinity,
                    child: AspectRatio(
                      aspectRatio: double.parse(
                          widget.courseVideos[currentIndex].aspectRatio),
                      child: videoPlayerController != null &&
                              videoPlayerController!.value.isInitialized
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: VideoPlayer(videoPlayerController!),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl:
                                    widget.courseVideos[currentIndex].thumbnail,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    widget.courseVideos[currentIndex].title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
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
                            videoPlayerController!.seekTo(p);
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
                            videoPlayerController!.pause();
                            setState(() {});
                          } else {
                            videoPlayerController!.play();
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
