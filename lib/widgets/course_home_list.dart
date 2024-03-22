import 'package:flutter/material.dart';
import 'package:podcasts_ruben/models/course_model.dart';
import 'package:podcasts_ruben/services/firebase_api.dart';
import 'package:podcasts_ruben/widgets/course_card.dart';
import 'package:podcasts_ruben/widgets/section_header.dart';
import 'package:provider/provider.dart';

class ProximosCursos extends StatelessWidget {
  const ProximosCursos({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: SectionHeader(
              title: 'Próximos cursos',
              actionRoute: '/info',
            ),
          ),
          const SizedBox(height: 20),
          StreamProvider.value(
            value: FirebaseApi.getCourses(),
            initialData: null,
            catchError: (context, error) => null,
            child: Consumer<List<CourseModel>?>(builder: (context, courses, b) {
              if (courses == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: courses.length > 5 ? 5 : courses.length,
                  itemBuilder: (context, index) {
                    return CourseCard(
                      courseModel: courses[index],
                      width: MediaQuery.of(context).size.width * .8,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
