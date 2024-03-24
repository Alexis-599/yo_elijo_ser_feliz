import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcasts_ruben/data.dart';
import 'package:podcasts_ruben/models/user_model.dart';
import 'package:podcasts_ruben/screens/buyed_courses.dart';
import 'package:podcasts_ruben/screens/profile_setup_screen.dart';
import 'package:podcasts_ruben/services/auth.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  final AppData appData = AppData();

  void logOut() async {
    await AuthService().signOut();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Consumer<UserModel?>(
        builder: (context, user, b) {
          if (user == null) {
            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Ingresar como invitado',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        onTap: () {
                          authService.signOut();
                          appData.isAdmin = false;
                        },
                        title: const Text(
                          'Cerrar sesión',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              GestureDetector(
                onTap: () => Get.to(() => ProfileSetupScreen(
                      userModel: user,
                    )),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: Platform.isAndroid ? 50 : 100, left: 17),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          image: user.imageUrl == null || user.imageUrl!.isEmpty
                              ? null
                              : DecorationImage(
                                  image: NetworkImage(user.imageUrl!),
                                  fit: BoxFit.cover,
                                ),
                        ),

                        // padding: const EdgeInsets.all(4),
                        child: user.imageUrl == null || user.imageUrl!.isEmpty
                            ? const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 60,
                              )
                            : Container(),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        user.username,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      const Divider(
                        indent: 0,
                        endIndent: 90,
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.video_collection_rounded,
                  color: Colors.white,
                ),
                onTap: () {
                  Get.to(() => const BuyedCourses());
                },
                title: const Text(
                  'Cursos Comprados',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onTap: () {
                  authService.signOut();
                  appData.isAdmin = false;
                },
                title: const Text(
                  'Cerrar sesión',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
