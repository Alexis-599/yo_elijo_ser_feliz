import 'package:flutter/material.dart';
import 'package:podcasts_ruben/screens/editable_playlist_screen.dart';
import 'package:podcasts_ruben/screens/playlist_screen.dart';
import 'package:podcasts_ruben/services/firebase_file.dart';
// import 'package:podcasts_ruben/screens/loading_screen.dart';
// import 'package:podcasts_ruben/services/firebase_api.dart';
import 'package:podcasts_ruben/services/models.dart';

class PlaylistCard extends StatelessWidget {
  const PlaylistCard({
    super.key,
    required this.playlist,
    required this.playlistImg,
    required this.playlistAuthorImg,
    required this.edit,
  });

  final Playlist playlist;
  final FirebaseFile playlistImg;
  final FirebaseFile playlistAuthorImg;
  final bool edit;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (edit) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditablePlaylistScreen(
                playlist: playlist,
                playlistImg: playlistImg,
                playlistAuthorImg: playlistAuthorImg,
              ),
            ),
          );
          // Get.toNamed('/editable_playlist',
          //     arguments: [playlist, playlistImg, playlistAuthorImg]);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PlaylistScreen(
                playlist: playlist,
                playlistImg: playlistImg,
                playlistAuthorImg: playlistAuthorImg,
              ),
            ),
          );
          // Get.toNamed('/playlist',
          //     arguments: [playlist, playlistImg, playlistAuthorImg]);
        }
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
            edit
                ? IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Borrar playlist'),
                          content: const Text(
                            'Estás seguro que quieres borrar esta playlist?\n\nSe perderán todos sus datos y contenido.',
                          ),
                          actions: [
                            TextButton(
                              child: const Text('SÍ, BORRAR'),
                              onPressed: () {
                                // TODO: Delete playlist

                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: const Text('CANCELAR'),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    }, // delete playlist
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.black45,
                    ),
                  )
                : IconButton(
                    onPressed: () {}, // start reproducing complete playlist
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
