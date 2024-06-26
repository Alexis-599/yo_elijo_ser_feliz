import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcasts_ruben/models/course_model.dart';
import 'package:podcasts_ruben/screens/course_detail.dart';
import 'package:podcasts_ruben/screens/edit_course.dart';

class CourseCard extends StatelessWidget {
  const CourseCard(
      {super.key,
      required this.courseModel,
      required this.width,
      this.isInfoScreen = false,
      this.isEditScreen = false});
  final CourseModel courseModel;
  final double width;
  final bool isInfoScreen;
  final bool isEditScreen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: isInfoScreen ? 0 : 15.0),
      child: GestureDetector(
        onTap: () => Get.to(
          () => !isEditScreen
              ? CourseDetailScreen(
                  courseModel: courseModel,
                )
              : EditCourse(courseModel: courseModel),
        ),
        child: Stack(
          children: [
            Container(
              height: 200,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(courseModel.image),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              width: MediaQuery.of(context).size.width * .6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courseModel.title.capitalizeFirst.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    courseModel.subtitle.capitalizeFirst!,
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Text(
                "\$MXN${courseModel.price}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
