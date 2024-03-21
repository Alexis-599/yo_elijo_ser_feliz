import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcasts_ruben/data.dart';
import 'package:podcasts_ruben/models/playlist_model.dart';
import 'package:podcasts_ruben/screens/editable_playlist_screen.dart';
import 'package:podcasts_ruben/screens/playlist_screen.dart';
import 'package:podcasts_ruben/services/firestore.dart';
import 'package:podcasts_ruben/widgets/alert_dialog.dart';
import 'package:podcasts_ruben/widgets/widget_shimmer.dart';

class P2Card extends StatelessWidget {
  const P2Card({
    super.key,
    required this.playlist,
    this.isEditScreen = false,
  });

  final PlayListModel playlist;
  final bool isEditScreen;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AppData().fetchPlaylistDetails(playlist.id),
      builder: (c, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: [
                ShimmerWidget.circular(
                  height: 75,
                  width: 100,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ShimmerWidget.rectangular(height: 10, width: 100),
                      SizedBox(height: 10),
                      ShimmerWidget.rectangular(height: 20, width: 250),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (snap.hasError) {
          return Center(
            child: Text(snap.error.toString()),
          );
        } else if (snap.hasData && snap.data != null) {
          final youtubePlaylist = snap.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: InkWell(
              onTap: () => Get.to(() => isEditScreen
                  ? EditablePlaylistScreen(
                      playlist: youtubePlaylist, playlistModel: playlist)
                  : PlaylistScreen(
                      playlist: youtubePlaylist,
                      playlistModel: playlist,
                    )),
              onLongPress: AppData().isAdmin
                  ? () {
                      Get.bottomSheet(
                        SizedBox(
                          height: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit Playlist'),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  FirestoreService()
                                      .deletePlayList(playlist.id);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                label: const Text(
                                  'Delete Playlist',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                        backgroundColor: Colors.white,
                      );
                    }
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 75,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image:
                                CachedNetworkImageProvider(playlist.creatorPic),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .45,
                            child: Text(
                              playlist.creatorName,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Text(
                            "${youtubePlaylist.itemCount} episodios",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  isEditScreen
                      ? GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => CustomAdaptiveAlertDialog(
                                alertMsg:
                                    'Are you sure you want to delete this playlist from your app?',
                                actiionBtnName: 'Yes',
                                onAction: () {
                                  FirestoreService()
                                      .deletePlayList(playlist.id);
                                },
                              ),
                            );
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.grey.shade700,
                            size: 25,
                          ),
                        )
                      : const Icon(
                          Icons.play_circle_fill_outlined,
                          color: Colors.white,
                          size: 35,
                        ),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
