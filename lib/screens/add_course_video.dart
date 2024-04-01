// import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:podcasts_ruben/models/course_model.dart';
// import 'package:podcasts_ruben/models/course_video.dart';
// import 'package:podcasts_ruben/services/firestore.dart';
// import 'package:podcasts_ruben/widgets/edit_text_field.dart';
// import 'package:podcasts_ruben/widgets/my_button.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:video_player/video_player.dart';

// class AddCourseVideo extends StatefulWidget {
//   const AddCourseVideo({super.key, required this.courseModel});

//   final CourseModel courseModel;

//   @override
//   State<AddCourseVideo> createState() => _AddCourseVideoState();
// }

// class _AddCourseVideoState extends State<AddCourseVideo> {
//   String? videoPath;
//   String? thumbnailPath;
//   VideoPlayerController? videoPlayerController;

//   _getVideo() async {
//     final pickedFile =
//         await ImagePicker().pickVideo(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       videoPath = pickedFile.path;
//       videoPlayerController = VideoPlayerController.file(File(videoPath!))
//         ..initialize().then((value) {
//           setState(() {});
//         }).whenComplete(() async {
//           await Future.delayed(const Duration(seconds: 1), () async {
//             final temp = await getTemporaryDirectory();
//             thumbnailPath =
//                 await screenshotController.captureAndSave(temp.path);
//           });
//         });
//     }
//   }

//   UploadTask? uploadTask;

//   Future<String> uploadVideoToFirebaseStorage({
//     required String uploadPath,
//     required String storingPath,
//     bool isVideo = false,
//   }) async {
//     final ref = FirebaseStorage.instance.ref().child(storingPath);
//     var ut = ref.putData(await File(uploadPath).readAsBytes());
//     setState(() {
//       uploadTask = ut;
//     });
//     var taskSnapshot = await ut.whenComplete(() {});
//     return taskSnapshot.ref.getDownloadURL();
//   }

//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final ScreenshotController screenshotController = ScreenshotController();

//   bool isLoading = false;

//   clearControllers() {
//     setState(() {
//       titleController.clear();
//       descriptionController.clear();
//       videoPath = null;
//       videoPlayerController = null;
//       thumbnailPath = null;
//       isLoading = false;
//       uploadTask = null;
//     });
//   }

//   _uploadVideo() async {
//     if (titleController.text.isEmpty &&
//         videoPlayerController == null &&
//         thumbnailPath == null) {
//       Fluttertoast.showToast(
//           msg: 'Por favor agregue el video y el título antes de subirlo.');
//       return;
//     }
//     setState(() {
//       isLoading = true;
//     });
//     final courseVideo = CourseVideo(
//       id: '',
//       courseId: widget.courseModel.id,
//       title: titleController.text.trim(),
//       description: descriptionController.text.trim(),
//       thumbnail: thumbnailPath!,
//       date: DateTime.now().toUtc().toString(),
//       link: await uploadVideoToFirebaseStorage(
//         uploadPath: videoPath!,
//         isVideo: true,
//         storingPath: 'courses/${widget.courseModel.id}/videos/${videoPath!}',
//       ),
//       aspectRatio: videoPlayerController!.value.aspectRatio.toString(),
//     );

//     await FirestoreService().postNewCourseVideo(courseVideo).whenComplete(() {
//       clearControllers();
//       Fluttertoast.showToast(msg: 'vídeo subido exitosamente');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Añadir video'),
//         centerTitle: true,
//         backgroundColor: Colors.amber,
//         elevation: 0,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(20.0),
//         children: [
//           GestureDetector(
//             onTap: () => _getVideo(),
//             child: videoPlayerController != null
//                 ? Container(
//                     height: 400,
//                     decoration: BoxDecoration(
//                       color: Colors.black,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Stack(
//                       children: [
//                         Center(
//                           child: AspectRatio(
//                             aspectRatio:
//                                 videoPlayerController!.value.aspectRatio,
//                             child: Screenshot(
//                               controller: screenshotController,
//                               child: VideoPlayer(videoPlayerController!),
//                             ),
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.bottomRight,
//                           child: IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 videoPlayerController!.value.isPlaying
//                                     ? videoPlayerController!.pause()
//                                     : videoPlayerController!.play();
//                               });
//                             },
//                             icon: Icon(
//                               videoPlayerController!.value.isPlaying
//                                   ? Icons.pause_circle
//                                   : Icons.play_circle_fill_outlined,
//                               size: 65,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.topRight,
//                           child: IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 videoPath = null;
//                                 thumbnailPath = null;
//                                 videoPlayerController = null;
//                               });
//                             },
//                             icon: const Icon(
//                               Icons.cancel_outlined,
//                               size: 30,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 : Container(
//                     height: 250,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: Colors.black12,
//                         width: 3,
//                       ),
//                       borderRadius: BorderRadius.circular(19),
//                     ),
//                     child: Icon(
//                       Icons.video_collection_outlined,
//                       color: Colors.grey.shade500,
//                       size: 120,
//                     ),
//                   ),
//           ),
//           const SizedBox(height: 15),
//           EditTextField(
//             label: 'Titulo del Video',
//             text: '',
//             onChanged: (c) {},
//             controller: titleController,
//           ),
//           const SizedBox(height: 15),
//           EditTextField(
//             label: 'Descripción del video',
//             text: '',
//             onChanged: (c) {},
//             controller: descriptionController,
//           ),
//           const SizedBox(height: 15),
//           if (uploadTask != null)
//             StreamBuilder<TaskSnapshot>(
//               stream: uploadTask?.snapshotEvents,
//               builder:
//                   (BuildContext context, AsyncSnapshot<TaskSnapshot> snapshot) {
//                 if (snapshot.hasData) {
//                   final data = snapshot.data!;
//                   double progress = data.bytesTransferred / data.totalBytes;
//                   return Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//                     child: LinearProgressIndicator(
//                       value: progress,
//                       minHeight: 10,
//                       semanticsLabel:
//                           '${(100 * progress).roundToDouble().toInt()}%',
//                     ),
//                   );
//                 } else {
//                   return const SizedBox(
//                     height: 0,
//                   );
//                 }
//               },
//             ),
//           const SizedBox(height: 15),
//           MyButton(
//             onTap: () async {
//               await _uploadVideo();
//             },
//             text: 'Subir vídeo',
//             isLoading: isLoading,
//           ),
//         ],
//       ),
//     );
//   }
// }
