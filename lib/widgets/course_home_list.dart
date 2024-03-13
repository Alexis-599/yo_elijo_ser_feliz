import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcasts_ruben/data.dart';
import 'package:podcasts_ruben/widgets/section_header.dart';

import '../screens/course_detail.dart';

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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.20,
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(width: 10);
              },
              scrollDirection: Axis.horizontal,
              itemCount: AppData().courses.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Get.to(() => CourseDetailScreen(
                      courseModel: AppData().courses[index])),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: const Image(
                      image: AssetImage('assets/images/yo_elijo_ser_feliz.jpg'),
                      height: 150,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
