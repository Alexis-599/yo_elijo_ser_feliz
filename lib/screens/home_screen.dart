import 'package:flutter/material.dart';

// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:podcasts_ruben/bottom_bar_navigation.dart';
import 'package:podcasts_ruben/data.dart';
import 'package:podcasts_ruben/screens/loading_screen.dart';
import 'package:podcasts_ruben/screens/login_or_register_screen.dart';

// import 'package:podcasts_ruben/screens/login_screen.dart';
import 'package:podcasts_ruben/services/auth.dart';
import 'package:podcasts_ruben/services/firebase_api.dart';

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
  @override
  Widget build(BuildContext context) {
    return hasUserAuthData
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
                hasUserAuthData = true;
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
  }
}

class _PlaylistMusic extends StatelessWidget {
  const _PlaylistMusic();

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
                          edit: false,
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
  _CustomDrawer();

  final user = AuthService().user!;

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
            hasUserAuthData = false;
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

class _Discover extends StatelessWidget {
  const _Discover();

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
