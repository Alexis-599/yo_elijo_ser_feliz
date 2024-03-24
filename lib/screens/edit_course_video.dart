import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcasts_ruben/models/course_video.dart';
import 'package:podcasts_ruben/services/firestore.dart';
import 'package:podcasts_ruben/widgets/edit_text_field.dart';
import 'package:podcasts_ruben/widgets/my_button.dart';
import 'package:screenshot/screenshot.dart';
import 'package:video_player/video_player.dart';

class EditCourseVideo extends StatefulWidget {
  const EditCourseVideo({super.key, required this.courseVideo});

  final CourseVideo courseVideo;

  @override
  State<EditCourseVideo> createState() => _EditCourseVideoState();
}

class _EditCourseVideoState extends State<EditCourseVideo> {
  String? videoPath;
  String? thumbnailPath;
  VideoPlayerController? videoPlayerController;

  _getVideo() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      videoPath = pickedFile.path;
      videoPlayerController?.dispose();
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

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late ScreenshotController screenshotController = ScreenshotController();

  bool isLoading = false;

  @override
  initState() {
    super.initState();
    titleController = TextEditingController(text: widget.courseVideo.title);
    descriptionController =
        TextEditingController(text: widget.courseVideo.description);
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.courseVideo.link))
          ..initialize().then((value) {
            setState(() {});
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
      id: widget.courseVideo.id,
      courseId: widget.courseVideo.courseId,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      thumbnail: thumbnailPath ?? widget.courseVideo.thumbnail,
      date: widget.courseVideo.date,
      link: videoPath ?? widget.courseVideo.link,
      aspectRatio: videoPlayerController!.value.aspectRatio.toString(),
    );

    await FirestoreService().editCourseVideo(courseVideo).whenComplete(() {
      // clearControllers();
      setState(() {
        isLoading = false;
      });
    });

    Get.back();
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Video'),
        centerTitle: true,
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              videoPlayerController != null
                  ? Container(
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: AspectRatio(
                              aspectRatio:
                                  videoPlayerController!.value.aspectRatio,
                              child: Screenshot(
                                controller: screenshotController,
                                child: VideoPlayer(videoPlayerController!),
                              ),
                            ),
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
                                _getVideo();

                                setState(() {
                                  videoPath = null;
                                  thumbnailPath = null;
                                  videoPlayerController = null;
                                });
                              },
                              icon: const Icon(
                                Icons.edit,
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
                text: 'Save',
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
                      Text('Please wait, saving...')
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
