// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:podcasts_ruben/services/firebase_file.dart';
// import 'package:podcasts_ruben/services/models.dart';
// import 'package:podcasts_ruben/services/firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:podcasts_ruben/models/course_model.dart';
import 'package:podcasts_ruben/models/course_video.dart';
import 'package:podcasts_ruben/models/playlist_model.dart';

class FirebaseApi {
  static Stream<List<PlayListModel>?> getPlaylists(String text) {
    return FirebaseFirestore.instance.collection('playlists').snapshots().map(
          (value) => value.docs
              .map((e) => PlayListModel.fromJson(e.data()))
              .where((element) => element.title
                  .toLowerCase()
                  .contains(text.trim().toLowerCase()))
              .toList(),
        );
  }

  static Stream<List<PlayListModel>?> getFilterPlaylists(List<String> ids) {
    return FirebaseFirestore.instance.collection('playlists').snapshots().map(
          (value) => value.docs
              .map((e) => PlayListModel.fromJson(e.data()))
              .where((element) => ids.contains(element.id))
              .toList(),
        );
  }

  static Stream<List<CourseModel>?> getFilterCourses(List<String> ids) {
    return FirebaseFirestore.instance.collection('courses').snapshots().map(
          (value) => value.docs
              .map((e) => CourseModel.fromJson(e.data()))
              .where((element) => ids.contains(element.id))
              .toList(),
        );
  }

  static Stream<List<CourseModel>?> getCourses() {
    return FirebaseFirestore.instance.collection('courses').snapshots().map(
          (value) =>
              value.docs.map((e) => CourseModel.fromJson(e.data())).toList(),
        );
  }

  static Stream<List<CourseVideo>?> getCourseVideos(String id, String text) {
    return FirebaseFirestore.instance
        .collection('courses')
        .doc(id)
        .collection('videos')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (value) => value.docs
              .map((e) => CourseVideo.fromJson(e.data()))
              .where((element) => element.title
                  .toLowerCase()
                  .contains(text.trim().toLowerCase()))
              .toList(),
        );
  }

  static Stream<List<CourseVideo>?> getSingleCourseVideos(String id) {
    return FirebaseFirestore.instance
        .collection('courses')
        .doc(id)
        .collection('videos')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (value) =>
              value.docs.map((e) => CourseVideo.fromJson(e.data())).toList(),
        );
  }

  static Stream<int?> getCourseVideosLength(String id) {
    return FirebaseFirestore.instance
        .collection('courses')
        .doc(id)
        .collection('videos')
        .snapshots()
        .map(
          (value) => value.docs
              .map((e) => CourseVideo.fromJson(e.data()))
              .toList()
              .length,
        );
  }
}
//   static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
//     Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

//   static Future<FirebaseFile> getFile(String path) async {
//     final ref = FirebaseStorage.instance.ref(path);
//     final name = ref.name;
//     final url = await ref.getDownloadURL();
//     return FirebaseFile(ref: ref, name: name, url: url);
//   }

//   static Future<List<FirebaseFile>> listAll(String path) async {
//     final ref = FirebaseStorage.instance.ref(path);
//     final result = await ref.listAll();
//     final urls = await _getDownloadLinks(result.items);

//     return urls
//         .asMap()
//         .map((index, url) {
//           final ref = result.items[index];
//           final name = ref.name;
//           final file = FirebaseFile(ref: ref, name: name, url: url);

//           return MapEntry(index, file);
//         })
//         .values
//         .toList();
//   }

//   static Future<List> getPlaylistMedia() async {
//     final playlists = await FirestoreService().getPlaylists(); // data base info
//     final playlistImg = await Future.wait(playlists.map(
//             (e) async => await getFile(e.img)));
//     final playlistAuthorImg = await Future.wait(playlists.map(
//             (e) async => await getFile(e.authorImg)));
//     return [playlists, playlistImg.toList(), playlistAuthorImg.toList()];
//   }

//   static Future<List> getVideosMediaFromPlaylist(Playlist playlist, int chunk, int limit) async {
//     final videos = await FirestoreService().getVideosFromPlaylist(
//         playlist,
//         chunk,
//         limit
//     );
//     return getVideosMedia(videos);
//   }

//   static Future<List> getRecentVideosMedia() async {
//     final videos = await FirestoreService().getRecentVideos();
//     return getVideosMedia(videos);
//   }

//   static Future<List> getVideosMedia(List<Video> videos) async {
//     final videoImg = await Future.wait(videos.map(
//             (e) async => await getFile(e.img)));
//     final videoAudio = await Future.wait(videos.map(
//             (e) async => await getFile(e.path)));
//     return [videos, videoImg.toList(), videoAudio.toList()];
//   }
// }