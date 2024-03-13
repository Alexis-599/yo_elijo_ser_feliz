import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:podcasts_ruben/models/user_model.dart';
import 'package:podcasts_ruben/services/models.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future addUserDetails(String email) async {
    await _db.collection('users').add({'email': email, 'role': 'user'});
  }

  postDetailsToFirestore({String? name, User? loginUser}) async {
    try {
      if (loginUser != null) {
        var ref = _db.collection('users').doc(loginUser.uid);
        await ref.get().then((value) {
          if (!value.exists) {
            var user = UserModel(
              id: ref.id,
              name: name ?? loginUser.displayName ?? 'N/A',
              username: loginUser.email!.split("@").first,
              email: loginUser.email!,
              imageUrl: loginUser.photoURL,
              isAdmin: false,
              coursesIds: [],
            );
            ref.set(user.toMap());
          }
        });
      }
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  postUserCourseIds(id) async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        var ref =
            _db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
        await ref.get().then((value) {
          if (value.exists) {
            ref.set({
              "coursesIds": FieldValue.arrayUnion([id]),
            });
          }
        });
      }
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  /// Reads all documents from the podcasts collection
  Future<List<Playlist>> getPlaylists() async {
    var ref = _db.collection('podcasts');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var playlists = data.map((d) => Playlist.fromJson(d));
    return playlists.toList();
  }

  /// Retrieves a single video(audio) from video document
  Future<Video> getVideo(String videoId) async {
    var ref = _db.collection('videos').doc(videoId);
    var snapshot = await ref.get();
    return Video.fromJson(snapshot.data() ?? {});
  }

  Future<List<Video>> getVideosFromPlaylist(
      Playlist playlist, int chunk, int limit) async {
    var reversedVideos = playlist.videos.reversed.toList();
    var chunkVideos = _chunk(reversedVideos, limit);
    var videos = await Future.wait(
        chunkVideos[chunk].map((video) async => await getVideo(video['id'])));
    return videos.toList();
  }

  List<List<dynamic>> _chunk(List<dynamic> array, int size) {
    List<List<dynamic>> chunks = [];
    int i = 0;
    while (i < array.length) {
      int j = i + size;
      chunks.add(array.sublist(i, j > array.length ? array.length : j));
      i = j;
    }
    return chunks;
  }

  Future<List<Video>> getRecentVideos() async {
    // get last 3 videos from each playlist to compare dates
    var playlists = await getPlaylists();
    List<String> videoDates = [];
    Map<String, String> videoIDs = {};
    for (int i = 0; i < playlists.length; i++) {
      var videos = playlists[i].videos.reversed.toList();
      for (int j = 0; j < 3; j++) {
        videoDates.add(videos[j]['date']);
        videoIDs[videos[j]['id']] = videos[j]['date'];
      }
    }
    // compare all dates and return corresponding videos
    List<String> recentDates = _compareDates(videoDates);
    List<Video> recentVideos = [];
    for (int i = 0; i < recentDates.length; i++) {
      for (var id in videoIDs.keys) {
        if (videoIDs[id] == recentDates[i]) {
          recentVideos.add(await getVideo(id));
        }
      }
    }
    return recentVideos;
  }

  /// Compares dates from a list of strings
  /// and returns a list of 5 most recent dates
  List<String> _compareDates(List<String> dates) {
    // date format: dd-mm-yyyy
    // change to format: yyyy-dd-mm for DateTime parsing
    List<DateTime> parsedDates = dates.map((date) {
      List<String> splitDate = date.split('-');
      return DateTime.utc(int.parse(splitDate[2]), int.parse(splitDate[1]),
          int.parse(splitDate[0]));
    }).toList();
    parsedDates.sort((a, b) => b.compareTo(a));
    List<DateTime> recentParsed = parsedDates.take(8).toList();

    //convert back to my format
    return recentParsed
        .map((date) => '${date.day.toString().padLeft(2, '0')}'
            '-${date.month.toString().padLeft(2, '0')}'
            '-${date.year}')
        .toList();
  }

  Stream<UserModel?>? get currentUserData {
    if (FirebaseAuth.instance.currentUser != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .map(
            (value) => UserModel.fromJson(value.data()!),
          );
    } else {
      return null;
    }
  }
}
