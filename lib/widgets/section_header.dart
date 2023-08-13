import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:podcasts_ruben/routes.dart';
import 'package:podcasts_ruben/screens/all_playlists.dart';
import 'package:podcasts_ruben/screens/home_screen.dart';
import 'package:podcasts_ruben/screens/info_screen.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.hasAction = true,
    this.actionText = 'Ver más',
    this.actionRoute = '/',
  });

  final String title;
  final bool hasAction;
  final String actionText;
  final String actionRoute;

  @override
  Widget build(BuildContext context) {
    Map<String,Widget> pages = {
      '/': const HomeScreen(),
      '/all_playlists': const AllPlaylists(),
      '/info': const InfoScreen(),
    };
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        hasAction
            ? InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                    pages[actionRoute] ?? const Placeholder(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              child: Text(
                  actionText,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white),
                ),
            )
            : Container(),
      ],
    );
  }
}
