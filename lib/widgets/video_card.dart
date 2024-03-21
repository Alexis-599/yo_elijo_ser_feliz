// import 'package:flutter/material.dart';
// import 'package:podcasts_ruben/screens/song_screen.dart';
// import 'package:podcasts_ruben/services/firebase_file.dart';
// import 'package:podcasts_ruben/services/models.dart';

// class VideoCard extends StatelessWidget {
//   const VideoCard({
//     super.key,
//     required this.video,
//     required this.videoImg,
//     required this.audio,
//   });

//   final Video video;
//   final FirebaseFile videoImg;
//   final FirebaseFile audio;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (_) => SongScreen(
//                     video: video, videoImg: videoImg, audio: audio)));
//       },
//       child: Container(
//         constraints: const BoxConstraints(
//           maxWidth: 150,
//           maxHeight: 150,
//         ),
//         child: Column(
//           // crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(15),
//               child: Image.network(
//                 videoImg.url,
//                 height: 150,
//                 width: 150,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               video.title,
//               style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//             Text(
//               video.podcast,
//               style: Theme.of(context).textTheme.bodySmall!,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
