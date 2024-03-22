import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcasts_ruben/models/course_model.dart';
import 'package:podcasts_ruben/models/course_video.dart';
import 'package:podcasts_ruben/screens/add_course_video.dart';
import 'package:podcasts_ruben/screens/course_video_player.dart';
import 'package:podcasts_ruben/services/firebase_api.dart';
import 'package:podcasts_ruben/widgets/widgets.dart';
import 'package:provider/provider.dart';

class CourseVideos extends StatefulWidget {
  const CourseVideos({super.key, required this.courseModel});

  final CourseModel courseModel;

  @override
  State<CourseVideos> createState() => _CourseVideosState();
}

class _CourseVideosState extends State<CourseVideos> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade200,
            Colors.blue.shade800,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Course Videos'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: StreamProvider.value(
          value: FirebaseApi.getCourseVideos(widget.courseModel.id),
          initialData: null,
          catchError: (context, error) => null,
          child: Consumer<List<CourseVideo>?>(
            builder: (context, courseVideos, b) {
              if (courseVideos == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return courseVideos.isEmpty
                  ? const Center(
                      child: Text('No videos added yet'),
                    )
                  : ListView.builder(
                      itemCount: courseVideos.length,
                      padding: const EdgeInsets.only(top: 15),
                      itemBuilder: (c, i) {
                        return P2CardCourseVideo(
                          course: courseVideos[i],
                          ontap: () => Get.to(() => CourseVideoPlayerScreen(
                                courseVideos: courseVideos,
                                currentVideoIndex: i,
                              )),
                        );
                      },
                    );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.to(() => AddCourseVideo(
                courseModel: widget.courseModel,
              )),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
