import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcasts_ruben/data.dart';
import 'package:podcasts_ruben/screens/playlist_screen.dart';
import 'package:podcasts_ruben/widgets/widget_shimmer.dart';

class P2Card extends StatelessWidget {
  const P2Card({super.key, required this.playListId});

  final String playListId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AppData().fetchPlaylistDetails(playListId),
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
          final playlist = snap.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: GestureDetector(
              onTap: () => Get.to(() => PlaylistScreen(playlist: playlist)),
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
                            image: CachedNetworkImageProvider(
                                playlist.thumbnailUrl),
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
                            width: 200,
                            child: Text(
                              playlist.title,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Text(
                            "${playlist.itemCount} episodios",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Icon(
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
