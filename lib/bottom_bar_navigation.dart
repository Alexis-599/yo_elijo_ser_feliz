import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:podcasts_ruben/screens/all_playlists.dart';
import 'package:podcasts_ruben/screens/home_screen.dart';
import 'package:podcasts_ruben/screens/info_screen.dart';
import 'package:podcasts_ruben/screens/login_screen.dart';
import 'package:podcasts_ruben/services/auth.dart';

int selectedIndex = 0;
List<Widget> pageList = [
  const HomeScreen(),
  const AllPlaylists(),
  const InfoScreen(),
];

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  List<Widget> pageList = [
    const HomeScreen(),
    const AllPlaylists(),
    const InfoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading');
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('error'),
          );
        } else if (snapshot.hasData) {
          return Scaffold(
            body: Center(
                child: pageList[_selectedIndex]
            ),
            bottomNavigationBar: Container(
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
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
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
            ),
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}