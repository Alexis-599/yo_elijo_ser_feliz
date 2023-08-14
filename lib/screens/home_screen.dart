import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:podcasts_ruben/bottom_bar_navigation.dart';
import 'package:podcasts_ruben/screens/loading_screen.dart';
import 'package:podcasts_ruben/screens/login_screen.dart';
import 'package:podcasts_ruben/services/auth.dart';
import 'package:podcasts_ruben/services/firebase_api.dart';
import 'package:podcasts_ruben/services/firestore.dart';
import 'package:podcasts_ruben/services/models.dart';
import 'package:podcasts_ruben/widgets/video_card.dart';
import 'package:podcasts_ruben/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('error'),
          );
        } else if (snapshot.hasData) {
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
              appBar: const _CustomAppBar(),
              bottomNavigationBar: NavBar(indexNum: 0),
              drawer: const _CustomDrawer(),
              body: SingleChildScrollView(
                child: Column(
                  children: const [
                    _ProximosCursos(),
                    _Discover(),
                    _PlaylistMusic(),
                  ],
                ),
              ),
            ),
          );
        } else {
          return LoginScreen();
        }
      },
    );
  }
}

class _PlaylistMusic extends StatelessWidget {
  const _PlaylistMusic({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        children: [
          const SectionHeader(
              title: 'Playlists', actionRoute: '/all_playlists'),
          FutureBuilder(
              future: FirebaseApi.getPlaylistMedia(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 20),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
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
                  // var playlists = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 20),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: PlaylistCard(
                          playlist: playlists[index],
                          playlistImg: playlistImgs[index],
                          playlistAuthorImg: playlistAuthorImgs[index],
                        ),
                      );
                    },
                  );
                } else {
                  return const Scaffold();
                }
              }),
        ],
      ),
    );
  }
}

class _CustomDrawer extends StatelessWidget {
  const _CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
            // padding: EdgeInsets.zero,
            children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: const Text('Cerrar sesión'),
              onPressed: () async {
                await AuthService().signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              },
            ),
          ),
        ]));
  }
}

class _ProximosCursos extends StatelessWidget {
  const _ProximosCursos({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: SectionHeader(
              title: 'Próximos cursos',
              actionRoute: '/info',
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.20,
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(width: 10);
              },
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: const Image(
                    image: AssetImage('assets/images/yo_elijo_ser_feliz.jpg'),
                    height: 150,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Discover extends StatelessWidget {
  const _Discover({
    super.key,
    // required this.songs,
  });

  // final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: SectionHeader(
              title: 'Publicado recientemente',
              hasAction: false,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.28, // 0.33
            child: FutureBuilder(
              future: FirebaseApi.getRecentVideosMedia(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 10);
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return const ShimmerVideo();
                    },
                  );
                } else if (snapshot.hasError) {
                  return const Text('Error');
                } else if (snapshot.hasData) {
                  var results = snapshot.data!;
                  var videos = results[0];
                  var videoImgs = results[1];
                  var videoAudios = results[2];
                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 10);
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      return VideoCard(
                        video: videos[index],
                        videoImg: videoImgs[index],
                        audio: videoAudios[index],
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const _CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      // leading: const Icon(Icons.grid_view, size: 35),
      actions: [
        Container(
            margin: const EdgeInsets.only(right: 20, top: 10),
            child: const Icon(FontAwesomeIcons.user)),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
