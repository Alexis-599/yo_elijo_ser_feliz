import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:podcasts_ruben/bottom_bar_navigation.dart';
import 'package:podcasts_ruben/data.dart';
import 'package:podcasts_ruben/models/user_model.dart';
import 'package:podcasts_ruben/screens/all_playlists.dart';
import 'package:podcasts_ruben/screens/info_screen.dart';
import 'package:podcasts_ruben/screens/login_or_register_screen.dart';

import 'package:podcasts_ruben/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser != null
        ? Dashboard()
        : const LoginOrRegisterScreen();
  }
}

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final screenList = [
    const DisplayScreen(),
    const AllPlaylists(),
    const InfoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<DashboardProvider>(context);

    return Scaffold(
      body: screenList[prov.navCurrentIndex],
      bottomNavigationBar: const NavBar(),
    );
  }
}

class DisplayScreen extends StatelessWidget {
  const DisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);

    final currentUser = context.watch<UserModel?>();
    if (currentUser != null) {
      AppData().isAdmin = currentUser.isAdmin;
    }

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.blue.shade800.withOpacity(1),
            Colors.amber.shade400.withOpacity(1),
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        // bottomNavigationBar: const NavBar(),
        drawer: CustomDrawer(),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              ProximosCursos(),
              // _Discover(),
              // _PlaylistMusic(),
            ],
          ),
        ),
      ),
    );
  }
}

// class _PlaylistMusic extends StatefulWidget {
//   const _PlaylistMusic();

//   @override
//   State<_PlaylistMusic> createState() => _PlaylistMusicState();
// }

// class _PlaylistMusicState extends State<_PlaylistMusic> {
//   AppData appData = AppData();

//   late Future<List<dynamic>> playlistMedia;

//   @override
//   void initState() {
//     super.initState();
//     playlistMedia = FirebaseApi.getPlaylistMedia();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
//       child: Column(
//         children: [
//           const SectionHeader(
//               title: 'Playlists', actionRoute: '/all_playlists'),
//           appData.playlistMedia.isEmpty
//               ? FutureBuilder(
//                   future: playlistMedia,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return ListView.builder(
//                         shrinkWrap: true,
//                         padding: const EdgeInsets.only(top: 20),
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: 4,
//                         itemBuilder: (context, index) {
//                           return const ShimmerPlaylist();
//                         },
//                       );
//                     } else if (snapshot.hasError) {
//                       return const Scaffold(
//                         body: Text('error'),
//                       );
//                     } else if (snapshot.hasData) {
//                       appData.playlistMedia = snapshot.data!;
//                       var playlists = appData.playlistMedia[0];
//                       var playlistImgs = appData.playlistMedia[1];
//                       var playlistAuthorImgs = appData.playlistMedia[2];
//                       // var playlists = snapshot.data!;
//                       return ListView.builder(
//                         shrinkWrap: true,
//                         padding: const EdgeInsets.only(top: 20),
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: 4,
//                         itemBuilder: (context, index) {
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 20),
//                             child: PlaylistCard(
//                               playlist: playlists[index],
//                               playlistImg: playlistImgs[index],
//                               playlistAuthorImg: playlistAuthorImgs[index],
//                               edit: false,
//                             ),
//                           );
//                         },
//                       );
//                     } else {
//                       return const Scaffold();
//                     }
//                   })
//               : ListView.builder(
//                   shrinkWrap: true,
//                   padding: const EdgeInsets.only(top: 20),
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: 4,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: PlaylistCard(
//                         playlist: appData.playlistMedia[0][index],
//                         playlistImg: appData.playlistMedia[1][index],
//                         playlistAuthorImg: appData.playlistMedia[2][index],
//                         edit: false,
//                       ),
//                     );
//                   },
//                 ),
//         ],
//       ),
//     );
//   }
// }


// class _Discover extends StatefulWidget {
//   const _Discover();

//   @override
//   State<_Discover> createState() => _DiscoverState();
// }

// class _DiscoverState extends State<_Discover> {
//   AppData appData = AppData();
//   late Future<List<dynamic>> recentVideos;

//   // late List<dynamic> videos;
//   // late List<dynamic> videoImgs;
//   // late List<dynamic> videoAudios;

//   @override
//   void initState() {
//     super.initState();
//     recentVideos = FirebaseApi.getRecentVideosMedia();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
//       child: Column(
//         children: [
//           const Padding(
//             padding: EdgeInsets.only(right: 20),
//             child: SectionHeader(
//               title: 'Publicado recientemente',
//               hasAction: false,
//             ),
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//             height: MediaQuery.of(context).size.height * 0.28, // 0.33
//             child: appData.recentVideos.isEmpty
//                 ? FutureBuilder(
//                     future: recentVideos,
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return ListView.separated(
//                           separatorBuilder: (context, index) {
//                             return const SizedBox(width: 10);
//                           },
//                           scrollDirection: Axis.horizontal,
//                           itemCount: 4,
//                           itemBuilder: (context, index) {
//                             return const ShimmerVideo();
//                           },
//                         );
//                       } else if (snapshot.hasError) {
//                         return const Text('Error');
//                       } else if (snapshot.hasData) {
//                         appData.recentVideos = snapshot.data!;
//                         var videos = appData.recentVideos[0];
//                         var videoImgs = appData.recentVideos[1];
//                         var videoAudios = appData.recentVideos[2];
//                         return ListView.separated(
//                           separatorBuilder: (context, index) {
//                             return const SizedBox(width: 10);
//                           },
//                           scrollDirection: Axis.horizontal,
//                           itemCount: videos.length,
//                           itemBuilder: (context, index) {
//                             return VideoCard(
//                               video: videos[index],
//                               videoImg: videoImgs[index],
//                               audio: videoAudios[index],
//                             );
//                           },
//                         );
//                       } else {
//                         return Container();
//                       }
//                     },
//                   )
//                 : ListView.separated(
//                     separatorBuilder: (context, index) {
//                       return const SizedBox(width: 10);
//                     },
//                     scrollDirection: Axis.horizontal,
//                     itemCount: appData.recentVideos[0].length,
//                     itemBuilder: (context, index) {
//                       return VideoCard(
//                         video: appData.recentVideos[0][index],
//                         videoImg: appData.recentVideos[1][index],
//                         audio: appData.recentVideos[2][index],
//                       );
//                     },
//                   ),
//           )
//         ],
//       ),
//     );
//   }
// }
