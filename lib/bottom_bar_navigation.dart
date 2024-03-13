import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<DashboardProvider>(context);
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
          selectedIndex: prov.navCurrentIndex,
          onTabChange: (index) {
            prov.changeIndex(index);
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

class DashboardProvider extends ChangeNotifier {
  int navCurrentIndex = 0;

  changeIndex(c) {
    navCurrentIndex = c;
    notifyListeners();
  }
}
