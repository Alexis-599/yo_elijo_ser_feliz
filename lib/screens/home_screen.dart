import 'package:flutter/material.dart';

// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:podcasts_ruben/bottom_bar_navigation.dart';
import 'package:podcasts_ruben/data.dart';
// import 'package:podcasts_ruben/main.dart';
import 'package:podcasts_ruben/screens/loading_screen.dart';
import 'package:podcasts_ruben/screens/login_or_register_screen.dart';

// import 'package:podcasts_ruben/screens/login_screen.dart';
import 'package:podcasts_ruben/services/auth.dart';
import 'package:podcasts_ruben/services/firebase_api.dart';
import 'package:podcasts_ruben/services/firestore.dart';

// import 'package:podcasts_ruben/services/firestore.dart';
// import 'package:podcasts_ruben/services/models.dart';
import 'package:podcasts_ruben/widgets/video_card.dart';
import 'package:podcasts_ruben/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppData appData = AppData();

  void setAdminStatus() async {
    bool isAdmin = await FirestoreService().getAdminStatus();
    setState(() {
      appData.isAdmin = isAdmin;
    });
  }

  @override
  Widget build(BuildContext context) {
    // AppData appData = AppData();
    // check to see if auth data is loaded so it doesn't load multiple times
    return appData.hasUserAuthData
        ? const _DisplayScreen()
        : StreamBuilder(
            stream: AuthService().userStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingScreen();
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('error'),
                );
              } else if (snapshot.hasData) {
                appData.hasUserAuthData = true;
                setAdminStatus();
                return const _DisplayScreen();
              } else {
                return const LoginOrRegisterScreen();
              }
            },
          );
  }
}

class _DisplayScreen extends StatelessWidget {
  const _DisplayScreen();

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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        bottomNavigationBar: NavBar(indexNum: 0),
        drawer: _CustomDrawer(),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              _ProximosCursos(),
              _Discover(),
              _PlaylistMusic(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaylistMusic extends StatefulWidget {
  const _PlaylistMusic();

  @override
  State<_PlaylistMusic> createState() => _PlaylistMusicState();
}

class _PlaylistMusicState extends State<_PlaylistMusic> {
  AppData appData = AppData();

  late Future<List<dynamic>> playlistMedia;

  @override
  void initState() {
    super.initState();
    playlistMedia = FirebaseApi.getPlaylistMedia();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        children: [
          const SectionHeader(
              title: 'Playlists', actionRoute: '/all_playlists'),
          appData.playlistMedia.isEmpty
              ? FutureBuilder(
                  future: playlistMedia,
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
                      appData.playlistMedia = snapshot.data!;
                      var playlists = appData.playlistMedia[0];
                      var playlistImgs = appData.playlistMedia[1];
                      var playlistAuthorImgs = appData.playlistMedia[2];
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
                              edit: false,
                            ),
                          );
                        },
                      );
                    } else {
                      return const Scaffold();
                    }
                  })
              : ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 20),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: PlaylistCard(
                        playlist: appData.playlistMedia[0][index],
                        playlistImg: appData.playlistMedia[1][index],
                        playlistAuthorImg: appData.playlistMedia[2][index],
                        edit: false,
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}

class _CustomDrawer extends StatelessWidget {
  _CustomDrawer();

  final user = AuthService().user!;
  final AppData appData = AppData();

  void logOut() async {
    await AuthService().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(children: [
        DrawerHeader(
          child: Column(
            children: [
              const Icon(
                Icons.person,
                color: Colors.white,
                size: 80,
              ),
              Text(
                'Usuario:',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              Text(
                user.email ?? 'INVITADO',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
          onTap: () {
            logOut();
            appData.hasUserAuthData = false;
            appData.isAdmin = false;
            appData.recentVideos = [];
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (route) => false);
          },
          title: const Text(
            'Cerrar sesión',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ]),
    );
  }
}

class _ProximosCursos extends StatelessWidget {
  const _ProximosCursos();

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

class _Discover extends StatefulWidget {
  const _Discover();

  @override
  State<_Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<_Discover> {
  AppData appData = AppData();
  late Future<List<dynamic>> recentVideos;

  // late List<dynamic> videos;
  // late List<dynamic> videoImgs;
  // late List<dynamic> videoAudios;

  @override
  void initState() {
    super.initState();
    recentVideos = FirebaseApi.getRecentVideosMedia();
  }

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
            child: appData.recentVideos.isEmpty
                ? FutureBuilder(
                    future: recentVideos,
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
                        appData.recentVideos = snapshot.data!;
                        var videos = appData.recentVideos[0];
                        var videoImgs = appData.recentVideos[1];
                        var videoAudios = appData.recentVideos[2];
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
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 10);
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: appData.recentVideos[0].length,
                    itemBuilder: (context, index) {
                      return VideoCard(
                        video: appData.recentVideos[0][index],
                        videoImg: appData.recentVideos[1][index],
                        audio: appData.recentVideos[2][index],
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
