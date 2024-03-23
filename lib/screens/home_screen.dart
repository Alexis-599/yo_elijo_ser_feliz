import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcasts_ruben/bottom_bar_navigation.dart';
import 'package:podcasts_ruben/data.dart';
import 'package:podcasts_ruben/models/playlist_model.dart';
import 'package:podcasts_ruben/models/user_model.dart';
import 'package:podcasts_ruben/models/youtube_video.dart';
import 'package:podcasts_ruben/screens/all_playlists.dart';
import 'package:podcasts_ruben/screens/info_screen.dart';
import 'package:podcasts_ruben/screens/login_or_register_screen.dart';
import 'package:podcasts_ruben/services/firebase_api.dart';

import 'package:podcasts_ruben/widgets/widgets.dart';
import 'package:podcasts_ruben/widgets/youtube_player.dart';
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
        drawer: CustomDrawer(),
        body: ListView(
          children: const [
            ProximosCursos(),
            RecentlyPublished(),
            RecentPlaylistHome(),
            SizedBox(height: 50)
          ],
        ),
      ),
    );
  }
}

class RecentlyPublished extends StatelessWidget {
  const RecentlyPublished({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Publicado recientemente',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 220,
          child: StreamProvider.value(
            value: FirebaseApi.getPlaylists(),
            initialData: null,
            catchError: (context, error) => null,
            child: Consumer<List<PlayListModel>?>(
                builder: (context, playlists, b) {
              if (playlists == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return FutureBuilder<List<YouTubeVideo>>(
                  future: AppData().fetchRecentPodcastVideosFromChannels(
                      playlists.map((e) => e.id).toList()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var video = snapshot.data![index];
                          return GestureDetector(
                            onTap: () => Get.to(() => VideoPlayerScreen(
                                youtubeVideos: snapshot.data!,
                                currentVideoIndex: index)),
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              width: 150,
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: video.thumbnailUrl,
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    video.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  });
            }),
          ),
        ),
      ],
    );
  }
}

class RecentPlaylistHome extends StatelessWidget {
  const RecentPlaylistHome({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<DashboardProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'lista de reproducción reciente',
            ontapAction: () => prov.changeIndex(1),
          ),
          const SizedBox(height: 15),
          StreamProvider.value(
            value: FirebaseApi.getPlaylists(),
            initialData: null,
            catchError: (context, error) => null,
            child: Consumer<List<PlayListModel>?>(
              builder: (context, playlists, b) {
                if (playlists == null) {
                  return const CircularProgressIndicator();
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: playlists.length > 5 ? 5 : playlists.length,
                  itemBuilder: (c, i) {
                    return P2Card(
                      playlist: playlists[i],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
