import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:podcasts_ruben/services/firebase_api.dart';
import 'package:podcasts_ruben/services/firebase_file.dart';
import 'package:podcasts_ruben/services/models.dart';

class EditablePlaylistScreen extends StatefulWidget {
  const EditablePlaylistScreen({super.key});

  @override
  State<EditablePlaylistScreen> createState() => _EditablePlaylistScreenState();
}

class _EditablePlaylistScreenState extends State<EditablePlaylistScreen> {
  Playlist playlist = Get.arguments[0];
  FirebaseFile playlistImg = Get.arguments[1];
  FirebaseFile playlistAuthorImg = Get.arguments[2];

  late Future<List<dynamic>> futureMedia;
  List<List<dynamic>> results = [[], [], []];
  var videos = [];
  var videosImgs = [];

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
      // videosDuration.addAll(newDurationResults.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10, top: 10),
            child: const Icon(Icons.search, size: 35),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.white,
        // backgroundColor: Colors.transparent,
        child: const Icon(Icons.add, size: 40, color: Colors.black87),
      ),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.amber.shade300,
                Colors.amber.shade100,
              ],
            ),
          ),
          child: SingleChildScrollView(
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
        _EditableImage(
            playlistFile: playlistAuthorImg,
            size: MediaQuery.of(context).size.height * 0.17),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [
              Text(
                playlist.author,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                playlist.description,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.normal, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SongSmallCard extends StatelessWidget {
  const _SongSmallCard({
    required this.video,
    required this.videoImg,
    // required this.videoDuration,
  });

  final Video video;
  final FirebaseFile videoImg;

  // final Duration? videoDuration;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          videoImg.url,
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.height * 0.09,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        video.title,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '58:34 ° ${video.date}',
        style: Theme.of(context).textTheme.bodySmall!,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {},
      ),
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
        GestureDetector(
          onTap: () {},
          child: _EditableImage(
            playlistFile: playlistFile,
            size: MediaQuery.of(context).size.height * 0.3,
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                playlist.title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.edit,
                color: Colors.black45,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _EditableImage extends StatelessWidget {
  const _EditableImage({
    required this.playlistFile,
    required this.size,
  });

  final FirebaseFile playlistFile;
  final double size;

  @override
  Widget build(BuildContext context) {
    double editSquareSize = size * 0.2;

    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            playlistFile.url,
            height: size,
            width: size,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: editSquareSize,
          height: editSquareSize,
          decoration: ShapeDecoration(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
            ),
            color: Colors.black.withOpacity(0.5),
          ),
          child: Icon(
            Icons.edit,
            color: Colors.white,
            size: editSquareSize * 0.6,
          ),
        ),
      ],
    );
  }
}
