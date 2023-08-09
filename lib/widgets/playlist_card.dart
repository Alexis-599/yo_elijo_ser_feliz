import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcasts_ruben/services/firebase_file.dart';
import 'package:podcasts_ruben/screens/loading_screen.dart';
import 'package:podcasts_ruben/services/firebase_api.dart';
import 'package:podcasts_ruben/services/models.dart';


class PlaylistCard extends StatelessWidget {
  const PlaylistCard({
    super.key,
    required this.playlist,
    required this.playlistImg,
    required this.playlistAuthorImg,
  });

  final Playlist playlist;
  final FirebaseFile playlistImg;
  final FirebaseFile playlistAuthorImg;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed('/playlist', arguments: [playlist, playlistImg,
          playlistAuthorImg]);
      },
      child: Container(
        height: 75,
        margin: const EdgeInsets.only(bottom: 10),
        // padding: const EdgeInsets.symmetric(horizontal: 20),
        // decoration: BoxDecoration(
        //   color: Colors.amber.shade600.withOpacity(0.6),
        //   borderRadius: BorderRadius.circular(15)
        // ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                playlistImg.url,
                height: 100,
                width: 75,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    playlist.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${playlist.videos.length} episodios',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.play_circle,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}