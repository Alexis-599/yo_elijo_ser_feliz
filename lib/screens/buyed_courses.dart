import 'package:flutter/material.dart';
import 'package:podcasts_ruben/models/course_model.dart';
import 'package:podcasts_ruben/models/user_model.dart';
import 'package:podcasts_ruben/services/firebase_api.dart';
import 'package:podcasts_ruben/widgets/course_card.dart';
import 'package:provider/provider.dart';

class BuyedCourses extends StatefulWidget {
  const BuyedCourses({super.key});

  @override
  State<BuyedCourses> createState() => _BuyedCoursesState();
}

class _BuyedCoursesState extends State<BuyedCourses> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserModel?>();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade400,
            Colors.blue.shade900,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              'Buy Playlist',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          body: currentUser == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: SizedBox(
                          height: 45,
                          child: TextFormField(
                            controller: searchController,
                            onChanged: (value) {
                              if (mounted) {
                                setState(() {});
                              }
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Buscar',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.grey.shade500),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey.shade500,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          children: [
                            StreamProvider.value(
                              value: FirebaseApi.getFilterCourses(
                                ids: currentUser.coursesIds!,
                                text: searchController.text,
                              ),
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: CourseCard(
                                        isInfoScreen: true,
                                        courseModel: courses[index],
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                    );
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
