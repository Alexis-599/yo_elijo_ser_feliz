import 'package:flutter/material.dart';
import 'package:podcasts_ruben/data.dart';
import 'package:podcasts_ruben/widgets/widgets.dart';

class AllPlaylists extends StatefulWidget {
  const AllPlaylists({super.key});

  @override
  State<AllPlaylists> createState() => _AllPlaylistsState();
}

class _AllPlaylistsState extends State<AllPlaylists> {
  // late Future<List<dynamic>> playlistMedia;
  AppData appData = AppData();

  @override
  void initState() {
    super.initState();
    // playlistMedia = FirebaseApi.getPlaylistMedia();
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
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          // bottomNavigationBar: const NavBar(indexNum: 1),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    // appData.isAdmin
                    //     ? IconButton(
                    //         onPressed: () {
                    //           Navigator.push(context,
                    //               MaterialPageRoute(builder: (context) {
                    //             return const EditPlaylistsScreen();
                    //           }));
                    //         },
                    //         icon: const Icon(Icons.add_box),
                    //         iconSize: 55,
                    //         color: Colors.white,
                    //       )
                    //     : const SizedBox.shrink(),
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
                const SizedBox(height: 15),
                Expanded(
                  child: ListView.builder(
                    itemCount: AppData.playListIds.length,
                    itemBuilder: (c, i) {
                      return P2Card(
                        playListId: AppData.playListIds[i],
                        playListIndex: i + 1,
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// const ShimmerPlaylist(),
                // appData.playlistMedia.isEmpty
                //     ? FutureBuilder(
                //         future: playlistMedia,
                //         builder: (context, snapshot) {
                //           if (snapshot.connectionState ==
                //               ConnectionState.waiting) {
                //             return ListView.builder(
                //               shrinkWrap: true,
                //               padding: const EdgeInsets.only(top: 20),
                //               physics: const NeverScrollableScrollPhysics(),
                //               itemCount: 7,
                //               itemBuilder: (context, index) {
                //                 return const ShimmerPlaylist();
                //               },
                //             );
                //           } else if (snapshot.hasError) {
                //             return const Scaffold(
                //               body: Text('error'),
                //             );
                //           } else if (snapshot.hasData) {
                //             appData.playlistMedia = snapshot.data!;
                //             var playlists = appData.playlistMedia[0];
                //             var playlistImgs = appData.playlistMedia[1];
                //             var playlistAuthorImgs = appData.playlistMedia[2];
                //             return ListView.builder(
                //               shrinkWrap: true,
                //               padding: const EdgeInsets.only(top: 20),
                //               physics: const NeverScrollableScrollPhysics(),
                //               // itemCount: 7,
                //               itemCount: playlists.length,
                //               itemBuilder: (context, index) {
                //                 // return buildPlaylistShimmer();
                //                 return PlaylistCard(
                //                   playlist: playlists[index],
                //                   playlistImg: playlistImgs[index],
                //                   playlistAuthorImg:
                //                       playlistAuthorImgs[index],
                //                   edit: false,
                //                 );
                //               },
                //             );
                //           } else {
                //             return const Scaffold();
                //           }
                //         },
                //       )
                //     : ListView.builder(
                //         shrinkWrap: true,
                //         padding: const EdgeInsets.only(top: 20),
                //         physics: const NeverScrollableScrollPhysics(),
                //         // itemCount: 7,
                //         itemCount: appData.playlistMedia[0].length,
                //         itemBuilder: (context, index) {
                //           // return buildPlaylistShimmer();
                //           return PlaylistCard(
                //             playlist: appData.playlistMedia[0][index],
                //             playlistImg: appData.playlistMedia[1][index],
                //             playlistAuthorImg: appData.playlistMedia[2]
                //                 [index],
                //             edit: false,
                //           );
                //         },
                //       ),