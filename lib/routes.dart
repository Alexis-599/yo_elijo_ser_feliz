import 'package:get/get.dart';

import 'package:podcasts_ruben/screens/all_playlists.dart';
// import 'package:podcasts_ruben/bottom_bar_navigation.dart';
import 'package:podcasts_ruben/screens/home_screen.dart';
import 'package:podcasts_ruben/screens/info_screen.dart';
import 'package:podcasts_ruben/screens/playlist_screen.dart';
import 'package:podcasts_ruben/screens/song_screen.dart';

// export 'package:podcasts_ruben/widgets/bottom_bar_navigation.dart';


var appRoutes = [
  // GetPage(name: '/', page: () => const NavBar()),
  GetPage(name: '/', page: () => const HomeScreen()),
  GetPage(name: '/song', page: () => const SongScreen()),
  GetPage(name: '/playlist', page: () => const PlaylistScreen()),
  GetPage(name: '/all_playlists', page: () => const AllPlaylists()),
  GetPage(name: '/info', page: () => const InfoScreen()),
];