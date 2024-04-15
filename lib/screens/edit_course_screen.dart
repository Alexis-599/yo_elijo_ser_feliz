import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcasts_ruben/models/course_model.dart';
import 'package:podcasts_ruben/screens/add_course.dart';
import 'package:podcasts_ruben/screens/edit_course.dart';
import 'package:podcasts_ruben/services/firebase_api.dart';
import 'package:podcasts_ruben/services/firestore.dart';
import 'package:podcasts_ruben/widgets/alert_dialog.dart';
import 'package:provider/provider.dart';

class EditCourseScreen extends StatelessWidget {
  const EditCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.amber.shade300,
            Colors.amber.shade100,
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade900,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Editar cursos',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => const AddCourse());
              },
              icon: const Icon(
                Icons.add_box,
                size: 35,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Column(
                  children: [
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
                            return EditCourseCard(courseModel: courses[index]);
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
    );
  }
}

class EditCourseCard extends StatelessWidget {
  const EditCourseCard({super.key, required this.courseModel});
  final CourseModel courseModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.to(() => EditCourse(
              courseModel: courseModel,
            ));
      },
      contentPadding: EdgeInsets.zero,
      leading: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: CachedNetworkImageProvider(courseModel.image),
            fit: BoxFit.fill,
          ),
        ),
      ),
      horizontalTitleGap: 10,
      visualDensity: const VisualDensity(vertical: 4),
      title: Text(
        courseModel.title,
        maxLines: 3,
        style: TextStyle(
          overflow: TextOverflow.ellipsis,
          color: Colors.grey.shade800,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        courseModel.subtitle,
        maxLines: 1,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      trailing: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (_) => CustomAdaptiveAlertDialog(
                  alertMsg:
                      '¿Estás seguro de que deseas eliminar este curso? esta acción eliminará todos los videos relacionados con este curso.',
                  actiionBtnName: 'Sí',
                  onAction: () {
                    FirestoreService().deleteCourse(courseModel.id);
                  }));
        },
        child: Icon(
          Icons.delete,
          color: Colors.grey.shade800,
          size: 35,
        ),
      ),
    );
  }
}
