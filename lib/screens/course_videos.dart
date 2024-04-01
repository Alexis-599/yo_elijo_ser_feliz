// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:podcasts_ruben/models/course_model.dart';
// import 'package:podcasts_ruben/models/course_video.dart';
// import 'package:podcasts_ruben/models/user_model.dart';
// import 'package:podcasts_ruben/screens/add_course_video.dart';
// import 'package:podcasts_ruben/screens/course_video_player.dart';
// import 'package:podcasts_ruben/services/firebase_api.dart';
// import 'package:podcasts_ruben/widgets/widgets.dart';
// import 'package:provider/provider.dart';

// class CourseVideos extends StatefulWidget {
//   const CourseVideos({super.key, required this.courseModel});

//   final CourseModel courseModel;

//   @override
//   State<CourseVideos> createState() => _CourseVideosState();
// }

// class _CourseVideosState extends State<CourseVideos> {
//   final searchController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             Colors.blue.shade200,
//             Colors.blue.shade800,
//           ],
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           title: const Text('Vídeos del curso'),
//           centerTitle: true,
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//         ),
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: Row(
//                 children: [
//                   context.watch<UserModel>().isAdmin
//                       ? GestureDetector(
//                           onTap: () {
//                             Get.to(() => AddCourseVideo(
//                                   courseModel: widget.courseModel,
//                                 ));
//                           },
//                           child: const Icon(
//                             Icons.add_box,
//                             size: 55,
//                             color: Colors.white,
//                           ),
//                         )
//                       : const SizedBox.shrink(),
//                   Flexible(
//                     child: SizedBox(
//                       height: 45,
//                       child: TextFormField(
//                         controller: searchController,
//                         onChanged: (value) {
//                           if (mounted) {
//                             setState(() {});
//                           }
//                         },
//                         decoration: InputDecoration(
//                           isDense: true,
//                           filled: true,
//                           fillColor: Colors.white,
//                           hintText: 'Buscar',
//                           hintStyle: Theme.of(context)
//                               .textTheme
//                               .bodyMedium!
//                               .copyWith(color: Colors.grey.shade500),
//                           prefixIcon: Icon(
//                             Icons.search,
//                             color: Colors.grey.shade500,
//                           ),
//                           contentPadding:
//                               const EdgeInsets.symmetric(vertical: 5),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             StreamProvider.value(
//               value: FirebaseApi.getCourseVideos(
//                   widget.courseModel.id, searchController.text),
//               initialData: null,
//               catchError: (context, error) => null,
//               child: Consumer<List<CourseVideo>?>(
//                 builder: (context, courseVideos, b) {
//                   if (courseVideos == null) {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                   return courseVideos.isEmpty
//                       ? const Center(
//                           child: Text(
//                               'No hay ningún vídeo disponible con este texto.'),
//                         )
//                       : Expanded(
//                           child: ListView.builder(
//                             itemCount: courseVideos.length,
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 20, vertical: 10),
//                             itemBuilder: (c, i) {
//                               return P2CardCourseVideo(
//                                 course: courseVideos[i],
//                                 ontap: () =>
//                                     Get.to(() => CourseVideoPlayerScreen(
//                                           courseVideos: courseVideos,
//                                           currentVideoIndex: i,
//                                         )),
//                               );
//                             },
//                           ),
//                         );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
