// import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:podcasts_ruben/services/firebase_file.dart';
// import 'package:podcasts_ruben/services/models.dart';
// import 'package:rxdart/rxdart.dart' as rxdart;

// class SongScreen extends StatefulWidget {
//   const SongScreen(
//       {super.key,
//       required this.video,
//       required this.videoImg,
//       required this.audio});
//   final Video video;
//   final FirebaseFile videoImg;
//   final FirebaseFile audio;

//   @override
//   State<SongScreen> createState() => _SongScreenState();
// }

// class _SongScreenState extends State<SongScreen> {
//   late AudioPlayer _audioPlayer;
//   // final _playlist = ConcatenatingAudioSource(
//   //   children: [],
//   // );

//   Stream<PositionData> get _positionDataStream =>
//       rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
//         _audioPlayer.positionStream,
//         _audioPlayer.bufferedPositionStream,
//         _audioPlayer.durationStream,
//         (position, bufferedPosition, duration) => PositionData(
//           position,
//           bufferedPosition,
//           duration ?? Duration.zero,
//         ),
//       );

//   @override
//   void initState() {
//     super.initState();
//     _audioPlayer = AudioPlayer()..setUrl(widget.audio.url);

//     // _audioPlayer.setAudioSource(
//     //   ConcatenatingAudioSource(
//     //     children: [
//     //       AudioSource.uri(Uri.parse('asset:///${video.path}')),
//     //     ],
//     //   ),
//     // );
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

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
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           // iconTheme: const IconThemeData(color: Colors.blueAccent),
//         ),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(15),
//               child: Image.network(
//                 widget.videoImg.url,
//                 height: MediaQuery.of(context).size.height * 0.43,
//                 width: MediaQuery.of(context).size.height * 0.43,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             _MusicPlayer(
//               video: widget.video,
//               positionDataStream: _positionDataStream,
//               audioPlayer: _audioPlayer,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _MusicPlayer extends StatelessWidget {
//   const _MusicPlayer({
//     required Video video,
//     required Stream<PositionData> positionDataStream,
//     required AudioPlayer audioPlayer,
//   })  : _video = video,
//         _audioPlayer = audioPlayer,
//         _positionDataStream = positionDataStream;

//   final Video _video;
//   final Stream<PositionData> _positionDataStream;
//   final AudioPlayer _audioPlayer;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             _video.title,
//             style: Theme.of(context).textTheme.headlineSmall!.copyWith(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             _video.podcast,
//             maxLines: 2,
//             style: Theme.of(context)
//                 .textTheme
//                 .bodyMedium!
//                 .copyWith(color: Colors.white),
//           ),
//           const SizedBox(height: 20),
//           StreamBuilder(
//             stream: _positionDataStream,
//             builder: (context, snapshot) {
//               final positionData = snapshot.data;
//               return ProgressBar(
//                 barHeight: 6,
//                 baseBarColor: Colors.grey[600],
//                 bufferedBarColor: Colors.grey,
//                 progressBarColor: Colors.white,
//                 thumbColor: Colors.white,
//                 thumbRadius: 8,
//                 timeLabelTextStyle: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 progress: positionData?.position ?? Duration.zero,
//                 buffered: positionData?.bufferedPosition ?? Duration.zero,
//                 total: positionData?.duration ?? Duration.zero,
//                 onSeek: _audioPlayer.seek,
//               );
//             },
//           ),
//           _Controls(audioPlayer: _audioPlayer),
//         ],
//       ),
//     );
//   }
// }

// class _Controls extends StatelessWidget {
//   const _Controls({
//     required this.audioPlayer,
//   });

//   final AudioPlayer audioPlayer;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         IconButton(
//           onPressed:
//               audioPlayer.hasPrevious ? audioPlayer.seekToPrevious : null,
//           iconSize: 60,
//           color: Colors.white,
//           icon: const Icon(Icons.skip_previous_rounded),
//         ),
//         StreamBuilder(
//           stream: audioPlayer.playerStateStream,
//           builder: (context, snapshot) {
//             final playerState = snapshot.data;
//             final processingState = playerState?.processingState;
//             final playing = playerState?.playing;
//             if (!(playing ?? false)) {
//               return IconButton(
//                 onPressed: audioPlayer.play,
//                 iconSize: 75,
//                 color: Colors.white,
//                 icon: const Icon(Icons.play_arrow_rounded),
//               );
//             } else if (processingState != ProcessingState.completed) {
//               return IconButton(
//                 onPressed: audioPlayer.pause,
//                 iconSize: 75,
//                 color: Colors.white,
//                 icon: const Icon(Icons.pause_rounded),
//               );
//             }
//             return const Icon(
//               Icons.play_arrow_rounded,
//               size: 75,
//               color: Colors.white,
//             );
//           },
//         ),
//         IconButton(
//           onPressed: audioPlayer.hasNext ? audioPlayer.seekToNext : null,
//           iconSize: 60,
//           color: Colors.white,
//           icon: const Icon(Icons.skip_next_rounded),
//         ),
//       ],
//     );
//   }
// }

// class PositionData {
//   const PositionData(
//     this.position,
//     this.bufferedPosition,
//     this.duration,
//   );

//   final Duration position;
//   final Duration bufferedPosition;
//   final Duration duration;
// }
