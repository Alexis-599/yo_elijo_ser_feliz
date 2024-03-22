import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcasts_ruben/models/course_model.dart';
import 'package:podcasts_ruben/models/course_video.dart';
import 'package:podcasts_ruben/services/firestore.dart';
import 'package:podcasts_ruben/widgets/edit_text_field.dart';
import 'package:podcasts_ruben/widgets/my_button.dart';
import 'package:screenshot/screenshot.dart';
import 'package:video_player/video_player.dart';

class AddCourseVideo extends StatefulWidget {
  const AddCourseVideo({super.key, required this.courseModel});

  final CourseModel courseModel;

  @override
  State<AddCourseVideo> createState() => _AddCourseVideoState();
}

class _AddCourseVideoState extends State<AddCourseVideo> {
  String? videoPath;
  String? thumbnailPath;
  VideoPlayerController? videoPlayerController;

  _getVideo() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      videoPath = pickedFile.path;
      videoPlayerController = VideoPlayerController.file(File(videoPath!))
        ..initialize().then((value) {
          setState(() {});
        }).whenComplete(() async {
          await Future.delayed(const Duration(seconds: 1), () async {
            final temp = await getTemporaryDirectory();
            thumbnailPath =
                await screenshotController.captureAndSave(temp.path);
          });
        });
    }
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ScreenshotController screenshotController = ScreenshotController();

  bool isLoading = false;

  clearControllers() {
    setState(() {
      titleController.clear();
      descriptionController.clear();
      videoPath = null;
      videoPlayerController = null;
      thumbnailPath = null;
      isLoading = false;
    });
  }

  _uploadVideo() async {
    if (titleController.text.isEmpty &&
        videoPlayerController == null &&
        thumbnailPath == null) {
      Fluttertoast.showToast(
          msg: 'Please add the video and title before uploading');
      return;
    }
    setState(() {
      isLoading = true;
    });
    final courseVideo = CourseVideo(
      id: '',
      courseId: widget.courseModel.id,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      thumbnail: thumbnailPath!,
      date: DateTime.now().toUtc().toString(),
      link: videoPath!,
      aspectRatio: videoPlayerController!.value.aspectRatio.toString(),
    );

    await FirestoreService().postNewCourseVideo(courseVideo).whenComplete(() {
      clearControllers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Video'),
        centerTitle: true,
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              GestureDetector(
                onTap: () => _getVideo(),
                child: videoPlayerController != null
                    ? AspectRatio(
                        aspectRatio: videoPlayerController!.value.aspectRatio,
                        child: Stack(
                          children: [
                            Screenshot(
                              controller: screenshotController,
                              child: VideoPlayer(videoPlayerController!),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    videoPlayerController!.value.isPlaying
                                        ? videoPlayerController!.pause()
                                        : videoPlayerController!.play();
                                  });
                                },
                                icon: Icon(
                                  videoPlayerController!.value.isPlaying
                                      ? Icons.pause_circle
                                      : Icons.play_circle_fill_outlined,
                                  size: 65,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    videoPath = null;
                                    thumbnailPath = null;
                                    videoPlayerController = null;
                                  });
                                },
                                icon: const Icon(
                                  Icons.cancel_outlined,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(19),
                        ),
                        child: Icon(
                          Icons.video_collection_outlined,
                          color: Colors.grey.shade500,
                          size: 120,
                        ),
                      ),
              ),
              const SizedBox(height: 15),
              EditTextField(
                label: 'Video title',
                text: '',
                onChanged: (c) {},
                controller: titleController,
              ),
              const SizedBox(height: 15),
              EditTextField(
                label: 'Video description',
                text: '',
                onChanged: (c) {},
                controller: descriptionController,
              ),
              const SizedBox(height: 15),
              MyButton(
                onTap: () => _uploadVideo(),
                text: 'Upload Video',
                isLoading: false,
              ),
            ],
          ),
          if (isLoading)
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
              ),
              child: Center(
                child: Container(
                  height: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 20),
                      Text('Please wait, uploading...')
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
