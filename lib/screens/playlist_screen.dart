import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcasts_ruben/services/firebase_file.dart';
import 'package:podcasts_ruben/services/models.dart';

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

  // Song song = Get.arguments ?? Song.songs[0];

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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _PlaylistInformation(
                    playlist: playlist,
                    playlistFile: playlistImg
                ),
                const SizedBox(height: 20),
                const Divider(),
                PresentationCard(
                    playlist: playlist,
                    playlistAuthorImg: playlistAuthorImg
                ),
                const Divider(),
                const SizedBox(height: 20),
                // Future builder
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: playlist.videos.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.toNamed('/song', arguments: playlist.videos[index]);
                      },
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            playlistImg.url,
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.height * 0.09,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          'playlist.songs[index].description',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        subtitle: Text(
                          '47:23 ° \${playlist.songs[index].releaseDate}',
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

class PresentationCard extends StatelessWidget {
  const PresentationCard({
    super.key,
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
        Column(
          children: [
            Text(
              'Información',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              '....... ....... .. ... \n. .. .... ...',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
        const SizedBox(width: 40),
        Column(
          children: [
            Text(
              'Programas',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              '....... ....... .. ... \n. .. .... ...',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}

class _PlaylistInformation extends StatelessWidget {
  const _PlaylistInformation({
    super.key,
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
