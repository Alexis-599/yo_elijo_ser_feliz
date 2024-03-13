import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcasts_ruben/data.dart';
import 'package:podcasts_ruben/screens/playlist_screen.dart';
import 'package:podcasts_ruben/widgets/widget_shimmer.dart';

class P2Card extends StatelessWidget {
  const P2Card(
      {super.key, required this.playListId, required this.playListIndex});

  final String playListId;
  final int playListIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: FutureBuilder(
        future: AppData().fetchPlaylistItems(playListId),
        builder: (c, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerWidget.rectangular(
                        height: 20,
                        width: 200,
                      ),
                      ShimmerWidget.rectangular(
                        height: 20,
                        width: 20,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ShimmerWidget.rectangular(
                          height: 150,
                          width: 200,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (snap.hasError) {
            return const Center(
              child: Text('error'),
            );
          } else if (snap.hasData && snap.data != null) {
            final videos = snap.data!.videos;
            return GestureDetector(
              onTap: () => Get.to(() => PlaylistScreen(
                  playListName: 'Playlist $playListIndex',
                  playlistModel: snap.data!,
                  playListId: playListId)),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Playlist $playListIndex',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(
                      Icons.navigate_next,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: videos!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final video = videos[index];
                        return Container(
                          width: 200,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(video.thumbnailUrl),
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}


// class PlaylistCard extends StatelessWidget {
//   const PlaylistCard({
//     super.key,
//     required this.playlist,
//     required this.playlistImg,
//     required this.playlistAuthorImg,
//     required this.edit,
//   });

//   final Playlist playlist;
//   final FirebaseFile playlistImg;
//   final FirebaseFile playlistAuthorImg;
//   final bool edit;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         // if (edit) {
//         //   Navigator.push(
//         //     context,
//         //     MaterialPageRoute(
//         //       builder: (_) => EditablePlaylistScreen(
//         //         playlist: playlist,
//         //         playlistImg: playlistImg,
//         //         playlistAuthorImg: playlistAuthorImg,
//         //       ),
//         //     ),
//         //   );
//         //   // Get.toNamed('/editable_playlist',
//         //   //     arguments: [playlist, playlistImg, playlistAuthorImg]);
//         // } else {
//         //   // Navigator.push(
//         //   //   context,
//         //   //   MaterialPageRoute(
//         //   //     builder: (_) => PlaylistScreen(
//         //   //       playlist: playlist,
//         //   //       playlistImg: playlistImg,
//         //   //       playlistAuthorImg: playlistAuthorImg,
//         //   //     ),
//         //   //   ),
//         //   // );
//         //   // Get.toNamed('/playlist',
//         //   //     arguments: [playlist, playlistImg, playlistAuthorImg]);
//         // }
//       },
//       child: Container(
//         height: 75,
//         margin: const EdgeInsets.only(bottom: 10),
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         decoration: BoxDecoration(
//             color: Colors.amber.shade600.withOpacity(0.6),
//             borderRadius: BorderRadius.circular(15)),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(15),
//               child: Image.network(
//                 playlistImg.url,
//                 height: 100,
//                 width: 75,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(width: 20),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     playlist.title,
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyLarge!
//                         .copyWith(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     '${playlist.videos.length} episodios',
//                     style: Theme.of(context).textTheme.bodySmall,
//                   ),
//                 ],
//               ),
//             ),
//             edit
//                 ? IconButton(
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           title: const Text('Borrar playlist'),
//                           content: const Text(
//                             'Estás seguro que quieres borrar esta playlist?\n\nSe perderán todos sus datos y contenido.',
//                           ),
//                           actions: [
//                             TextButton(
//                               child: const Text('SÍ, BORRAR'),
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                             ),
//                             TextButton(
//                               child: const Text('CANCELAR'),
//                               onPressed: () => Navigator.pop(context),
//                             ),
//                           ],
//                         ),
//                       );
//                     }, // delete playlist
//                     icon: const Icon(
//                       Icons.delete,
//                       color: Colors.black45,
//                     ),
//                   )
//                 : IconButton(
//                     onPressed: () {}, // start reproducing complete playlist
//                     icon: const Icon(
//                       Icons.play_circle,
//                       color: Colors.white,
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
