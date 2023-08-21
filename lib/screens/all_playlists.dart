import 'package:flutter/material.dart';
import 'package:podcasts_ruben/bottom_bar_navigation.dart';
import 'package:podcasts_ruben/screens/edit_playlists_screen.dart';
import 'package:podcasts_ruben/services/firebase_api.dart';
import 'package:podcasts_ruben/services/firestore.dart';
import 'package:podcasts_ruben/widgets/widgets.dart';
// import 'package:shimmer/shimmer.dart';

class AllPlaylists extends StatefulWidget {
  const AllPlaylists({super.key});

  @override
  State<AllPlaylists> createState() => _AllPlaylistsState();
}

class _AllPlaylistsState extends State<AllPlaylists> {
  late Future<List<dynamic>> playlistMedia;
  late bool _isAdmin = true;

  @override
  void initState() {
    super.initState();
    checkAdminStatus();
    playlistMedia = FirebaseApi.getPlaylistMedia();
  }

  void checkAdminStatus() async {
    setState(() async {
      _isAdmin = await FirestoreService().getAdminStatus();
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
                  Row(
                    children: [
                      _isAdmin
                          ? IconButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return const EditPlaylistsScreen();
                                    }));
                              },
                              icon: const Icon(Icons.add_box),
                              iconSize: 55,
                              color: Colors.white,
                            )
                          : const SizedBox.shrink(),
                      Flexible(
                        child: TextFormField(
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
                      ),
                    ],
                  ),
                  // const ShimmerPlaylist(),
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
                              edit: false,
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


