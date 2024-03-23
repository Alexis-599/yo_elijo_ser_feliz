import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcasts_ruben/data.dart';
import 'package:podcasts_ruben/models/course_model.dart';
import 'package:podcasts_ruben/screens/add_course.dart';
import 'package:podcasts_ruben/services/firebase_api.dart';
import 'package:podcasts_ruben/widgets/course_card.dart';
import 'package:provider/provider.dart';

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
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
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
                                ? GestureDetector(
                                    onTap: () {
                                      Get.to(() => const AddCourse());
                                    },
                                    child: const Icon(
                                      Icons.add_box,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                        StreamProvider.value(
                          value: FirebaseApi.getCourses(),
                          initialData: null,
                          catchError: (c, v) => null,
                          child: Consumer<List<CourseModel>?>(
                              builder: (context, courses, b) {
                            if (courses == null) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: courses.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: CourseCard(
                                    isInfoScreen: true,
                                    courseModel: courses[index],
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                );
                              },
                            );
                          }),
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
                        const SizedBox(height: 30),
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
