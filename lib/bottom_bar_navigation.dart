import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:podcasts_ruben/screens/all_playlists.dart';
import 'package:podcasts_ruben/screens/home_screen.dart';
import 'package:podcasts_ruben/screens/info_screen.dart';
import 'package:podcasts_ruben/screens/login_screen.dart';
import 'package:podcasts_ruben/services/auth.dart';

class NavBar extends StatelessWidget {
  int indexNum = 0;

  NavBar({super.key, required this.indexNum});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: GNav(
          iconSize: 30,
          backgroundColor: Colors.black,
          color: Colors.grey,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.grey.shade900,
          gap: 20,
          selectedIndex: indexNum,
          onTabChange: (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const HomeScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
                break;
              case 1:
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const AllPlaylists(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
                break;
              case 2:
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const InfoScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
                break;
            }
          },
          padding: const EdgeInsets.all(16),
          tabs: const [
            GButton(
              icon: Icons.home_outlined,
              text: 'Home',
            ),
            GButton(
              icon: Icons.video_library_outlined,
              text: 'Playlists',
            ),
            GButton(
              icon: Icons.info_outline,
              text: 'Info',
            ),
          ],
        ),
      ),
    );
  }
}
