import 'package:flutter/material.dart';
import 'package:podcasts_ruben/bottom_bar_navigation.dart';
import 'package:podcasts_ruben/services/firebase_api.dart';
import 'package:podcasts_ruben/widgets/widgets.dart';
import 'package:shimmer/shimmer.dart';

class AllPlaylists extends StatelessWidget {
  const AllPlaylists({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.blue.shade800.withOpacity(1),
            Colors.amber.shade400.withOpacity(1),
          ])),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          bottomNavigationBar: NavBar(indexNum: 1),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Buscar',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.grey.shade500),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade500,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  // const ShimmerPlaylist(),
                  FutureBuilder(
                    future: FirebaseApi.getPlaylistMedia(),
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
                        var playlistFiles = results[1];
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
                              playlistImg: playlistFiles[index],
                              playlistAuthorImg: playlistAuthorImgs[index],
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


