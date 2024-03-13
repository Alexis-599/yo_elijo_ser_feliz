import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcasts_ruben/data.dart';
import 'package:podcasts_ruben/screens/add_course.dart';
import 'package:podcasts_ruben/screens/course_detail.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

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
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            // bottomNavigationBar: const NavBar(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Próximos cursos',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                            ),
                            AppData().isAdmin
                                ? IconButton(
                                    onPressed: () {
                                      Get.to(() => const AddCourse());
                                      // Navigator.push(context,
                                      //     MaterialPageRoute(builder: (context) {
                                      //   return const EditPlaylistsScreen();
                                      // }));
                                    },
                                    icon: const Icon(Icons.add_box),
                                    iconSize: 50,
                                    color: Colors.white,
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 20),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: AppData().courses.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () => Get.to(() => CourseDetailScreen(
                                      courseModel: AppData().courses[index],
                                    )),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image(
                                    image: AssetImage(
                                        AppData().courses[index].image),
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image(
                              image: AssetImage('assets/images/spotify.png'),
                              height: 80,
                              // width: 150,
                              fit: BoxFit.cover,
                            ),
                            Image(
                              image: AssetImage('assets/images/youtube.png'),
                              height: 73,
                              // width: 150,
                              // fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
