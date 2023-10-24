import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

// import 'package:just_audio/just_audio.dart';
import 'package:podcasts_ruben/services/firebase_api.dart';
import 'package:podcasts_ruben/services/firebase_file.dart';

// import 'package:podcasts_ruben/services/firestore.dart';
import 'package:podcasts_ruben/services/models.dart';
// import 'package:podcasts_ruben/widgets/widget_shimmer.dart';

// import '../models/playlist_model.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  Playlist playlist = Get.arguments[0];
  FirebaseFile playlistImg = Get.arguments[1];
  FirebaseFile playlistAuthorImg = Get.arguments[2];

  late Future<List<dynamic>> futureMedia;
  List<List<dynamic>> results = [[], [], []];
  var videos = [];
  var videosImgs = [];
  var videosAudios = [];

  // var videosDuration = [];
  final controller = ScrollController();
  int chunk = 0;
  bool hasMore = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    fetch();

    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  // Future<Duration?> getDuration(String path) async {
  //   final player = AudioPlayer();
  //   var duration = await player.setUrl(path);
  //   return duration;
  // }

  Future fetch() async {
    if (isLoading) return;
    isLoading = true;
    int limit = 15;
    final newResults =
        await FirebaseApi.getVideosMediaFromPlaylist(playlist, chunk, limit);
    // final newDurationResults = await Future.wait(newResults[0].map(
    //         (video) async => await getDuration(video.path)));
    setState(() {
      chunk++;
      isLoading = false;
      if (newResults[0].length < limit) {
        hasMore = false;
      }

      for (int i = 0; i < results.length; i++) {
        results[i].addAll(newResults[i]);
      }
      // results.addAll(newResults);
      videos = results[0];
      videosImgs = results[1];
      videosAudios = results[2];
      // videosDuration.addAll(newDurationResults.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.blue.shade800.withOpacity(0.8),
            Colors.amber.shade400.withOpacity(0.8),
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10, top: 10),
              child: const Icon(Icons.search, size: 35),
            ),
          ],
        ),
        body: SingleChildScrollView(
          controller: controller,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _PlaylistInformation(
                    playlist: playlist, playlistFile: playlistImg),
                const SizedBox(height: 20),
                const Divider(),
                _PresentationCard(
                    playlist: playlist, playlistAuthorImg: playlistAuthorImg),
                const Divider(),
                const SizedBox(height: 20),
                // Future builder
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: videos.length + 1,
                  itemBuilder: (context, index) {
                    if (index < videos.length) {
                      return _SongSmallCard(
                        video: videos[index],
                        videoImg: videosImgs[index],
                        videoAudio: videosAudios[index],
                        // videoDuration: videosDuration[index],
                      );
                    } else {
                      return Center(
                        child: hasMore
                            ? const SpinKitChasingDots(
                                color: Colors.white,
                                size: 50.0,
                              )
                            : const SizedBox.shrink(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SongSmallCard extends StatefulWidget {
  const _SongSmallCard({
    required this.video,
    required this.videoImg,
    required this.videoAudio,
    // required this.videoDuration,
  });

  final Video video;
  final FirebaseFile videoImg;
  final FirebaseFile videoAudio;

  @override
  State<_SongSmallCard> createState() => _SongSmallCardState();
}

class _SongSmallCardState extends State<_SongSmallCard> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer()..setUrl(widget.videoAudio.url);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) {
      return '--:--';
    }
    else {
      String minutes = duration.inMinutes.toString().padLeft(2, '0');
      String seconds =
      duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed('/song', arguments: [widget.video, widget.videoImg, widget.videoAudio]);
      },
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            widget.videoImg.url,
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.height * 0.09,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          widget.video.title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Text(
          '${_formatDuration(_audioPlayer.duration)} ° ${widget.video.date}',
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.white),
        ),
        trailing: const Icon(
          Icons.play_circle,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _PresentationCard extends StatelessWidget {
  const _PresentationCard({
    required this.playlist,
    required this.playlistAuthorImg,
  });

  final Playlist playlist;
  final FirebaseFile playlistAuthorImg;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            playlistAuthorImg.url,
            height: MediaQuery.of(context).size.height * 0.17,
            width: MediaQuery.of(context).size.height * 0.17,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [
              Text(
                playlist.author,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                playlist.description,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlaylistInformation extends StatelessWidget {
  const _PlaylistInformation({
    required this.playlist,
    required this.playlistFile,
  });

  final Playlist playlist;
  final FirebaseFile playlistFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            playlistFile.url,
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.height * 0.3,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          playlist.title,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}
