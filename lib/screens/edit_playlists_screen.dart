import 'package:flutter/material.dart';
import 'package:podcasts_ruben/main.dart';
import 'package:podcasts_ruben/services/firebase_api.dart';
import 'package:podcasts_ruben/widgets/playlist_card.dart';
import 'package:podcasts_ruben/widgets/widget_shimmer.dart';

class EditPlaylistsScreen extends StatefulWidget {
  const EditPlaylistsScreen({super.key});

  @override
  State<EditPlaylistsScreen> createState() => _EditPlaylistsScreenState();
}

class _EditPlaylistsScreenState extends State<EditPlaylistsScreen> {
  late Future<List<dynamic>> playlistMedia;

  @override
  void initState() {
    super.initState();
    playlistMedia = FirebaseApi.getPlaylistMedia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {}, // add playlist
                icon: const Icon(Icons.add_box),
                iconSize: 45,
              )),
        ],
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
              ])),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  FutureBuilder(
                    future: playlistMedia,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 20),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 7,
                          itemBuilder: (context, index) {
                            return const ShimmerPlaylist();
                          },
                        );
                      } else if (snapshot.hasError) {
                        return const Scaffold(
                          body: Text('error'),
                        );
                      } else if (snapshot.hasData) {
                        var results = snapshot.data!;
                        var playlists = results[0];
                        var playlistImgs = results[1];
                        var playlistAuthorImgs = results[2];
                        return ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 20),
                          physics: const NeverScrollableScrollPhysics(),
                          // itemCount: 7,
                          itemCount: playlists.length,
                          itemBuilder: (context, index) {
                            // return buildPlaylistShimmer();
                            return PlaylistCard(
                              playlist: playlists[index],
                              playlistImg: playlistImgs[index],
                              playlistAuthorImg: playlistAuthorImgs[index],
                              edit: true,
                            );
                          },
                        );
                      } else {
                        return const Scaffold();
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
