import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:podcasts_ruben/models/course_model.dart';
import 'package:podcasts_ruben/models/course_video.dart';
import 'package:podcasts_ruben/models/playlist_model.dart';
import 'package:podcasts_ruben/models/user_model.dart';

class FirestoreService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // var mediaUploadTasks = <UploadTask>[];

  // bool isTrue = false;

  toggleIsTrue() {
    notifyListeners();
  }

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
      throw Exception(e);
      // Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> editUserDetails(UserModel userModel) async {
    try {
      var ref = _db.collection('users').doc(userModel.id);
      if (userModel.imageUrl != null &&
          !userModel.imageUrl!.contains('http')) {}
      final newModel = userModel.copyWith(
        imageUrl:
            userModel.imageUrl != null && !userModel.imageUrl!.contains('http')
                ? await uploadFileToStorageAndGetLink(
                    uploadPath: userModel.imageUrl!,
                    storingPath: 'users/${userModel.id}/profile_pic')
                : userModel.imageUrl,
      );
      await ref.update(newModel.toMap());
    } on FirebaseException catch (e) {
      throw Exception(e);
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
      throw Exception(e);
    }
  }

  Future<void> postNewPlayList(PlayListModel playListModel) async {
    final authorImage = await uploadFileToStorageAndGetLink(
      uploadPath: playListModel.creatorPic,
      storingPath: 'playlists/${playListModel.id}/authorImage',
    );
    final thumbnail = await uploadFileToStorageAndGetLink(
        uploadPath: playListModel.thumbnail,
        storingPath: 'playlists/${playListModel.id}/thumbnail');
    if (authorImage != null && thumbnail != null) {
      final p = playListModel.copyWith(
        creatorPic: authorImage,
        thumbnail: thumbnail,
      );
      await _db.collection('playlists').doc(p.id).set(
            p.toMap(),
          );
    }
  }

  Future<void> deletePlayList(String id) async {
    await _db.collection('playlists').doc(id).delete();
  }

  Future<void> editPlayList(PlayListModel playListModel) async {
    final p = playListModel.copyWith(
        creatorPic: playListModel.creatorPic.contains('http')
            ? playListModel.creatorPic
            : await uploadFileToStorageAndGetLink(
                uploadPath: playListModel.creatorPic,
                storingPath: 'playlists/${playListModel.id}/authorImage',
              ),
        thumbnail: playListModel.thumbnail.contains('http')
            ? playListModel.thumbnail
            : await uploadFileToStorageAndGetLink(
                uploadPath: playListModel.thumbnail,
                storingPath: 'playlists/${playListModel.id}/thumbnail',
              ));
    await _db.collection('playlists').doc(p.id).update(
          p.toMap(),
        );
  }

  // clearList() {
  //   mediaUploadTasks.clear();
  //   notifyListeners();
  // }

  Future<String?> uploadFileToStorageAndGetLink({
    required String uploadPath,
    required String storingPath,
    bool isVideo = false,
  }) async {
    final ref = FirebaseStorage.instance.ref().child(storingPath);
    return await ref
        .putData(await File(uploadPath).readAsBytes())
        .then((p0) => p0.ref.getDownloadURL());
  }

  Future<void> postNewCourse(CourseModel courseModel) async {
    try {
      final courseRef = FirebaseFirestore.instance.collection('courses').doc();
      final newCourseModel = courseModel.copyWith(
          id: courseRef.id,
          image: await uploadFileToStorageAndGetLink(
            uploadPath: courseModel.image,
            storingPath: 'courses/${courseRef.id}/thumbnail',
          ));
      await courseRef.set(newCourseModel.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editCourse(CourseModel courseModel) async {
    try {
      String? newImage;
      if (!courseModel.image.contains('http')) {
        newImage = await uploadFileToStorageAndGetLink(
          uploadPath: courseModel.image,
          storingPath: 'courses/${courseModel.id}/thumbnail',
        );
      } else {
        newImage = courseModel.image;
      }
      final courseRef =
          FirebaseFirestore.instance.collection('courses').doc(courseModel.id);
      final newCourseModel = courseModel.copyWith(image: newImage);
      await courseRef.set(newCourseModel.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postNewCourseVideo(CourseVideo courseVideo) async {
    try {
      final videoRef = FirebaseFirestore.instance
          .collection('courses')
          .doc(courseVideo.courseId)
          .collection('videos')
          .doc();
      final newCourseModel = courseVideo.copyWith(
        id: videoRef.id,
        thumbnail: await uploadFileToStorageAndGetLink(
          uploadPath: courseVideo.thumbnail,
          storingPath:
              'courses/${courseVideo.courseId}/${videoRef.id}/thumbnail',
        ),
        link: courseVideo.link,
        date: DateTime.now().toUtc().toString(),
      );
      await videoRef.set(newCourseModel.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editCourseVideo(CourseVideo courseVideo) async {
    try {
      final videoRef = FirebaseFirestore.instance
          .collection('courses')
          .doc(courseVideo.courseId)
          .collection('videos')
          .doc(courseVideo.id);
      final newCourseModel = courseVideo.copyWith(
        thumbnail: courseVideo.thumbnail.contains('http')
            ? courseVideo.thumbnail
            : await uploadFileToStorageAndGetLink(
                uploadPath: courseVideo.thumbnail,
                storingPath:
                    'courses/${courseVideo.courseId}/${videoRef.id}/thumbnail',
              ),
        link: courseVideo.link,
      );
      await videoRef.set(newCourseModel.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCourse(String id) async {
    try {
      await FirebaseFirestore.instance.collection('courses').doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCourseVideo(CourseVideo courseVideo) async {
    try {
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseVideo.courseId)
          .collection('videos')
          .doc(courseVideo.id)
          .delete();
    } catch (e) {
      rethrow;
    }
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


// /// Reads all documents from the podcasts collection
  // Future<List<Playlist>> getPlaylists() async {
  //   var ref = _db.collection('podcasts');
  //   var snapshot = await ref.get();
  //   var data = snapshot.docs.map((s) => s.data());
  //   var playlists = data.map((d) => Playlist.fromJson(d));
  //   return playlists.toList();
  // }

  // /// Retrieves a single video(audio) from video document
  // Future<Video> getVideo(String videoId) async {
  //   var ref = _db.collection('videos').doc(videoId);
  //   var snapshot = await ref.get();
  //   return Video.fromJson(snapshot.data() ?? {});
  // }

  // Future<List<Video>> getVideosFromPlaylist(
  //     Playlist playlist, int chunk, int limit) async {
  //   var reversedVideos = playlist.videos.reversed.toList();
  //   var chunkVideos = _chunk(reversedVideos, limit);
  //   var videos = await Future.wait(
  //       chunkVideos[chunk].map((video) async => await getVideo(video['id'])));
  //   return videos.toList();
  // }

  // List<List<dynamic>> _chunk(List<dynamic> array, int size) {
  //   List<List<dynamic>> chunks = [];
  //   int i = 0;
  //   while (i < array.length) {
  //     int j = i + size;
  //     chunks.add(array.sublist(i, j > array.length ? array.length : j));
  //     i = j;
  //   }
  //   return chunks;
  // }

  // Future<List<Video>> getRecentVideos() async {
  //   // get last 3 videos from each playlist to compare dates
  //   var playlists = await getPlaylists();
  //   List<String> videoDates = [];
  //   Map<String, String> videoIDs = {};
  //   for (int i = 0; i < playlists.length; i++) {
  //     var videos = playlists[i].videos.reversed.toList();
  //     for (int j = 0; j < 3; j++) {
  //       videoDates.add(videos[j]['date']);
  //       videoIDs[videos[j]['id']] = videos[j]['date'];
  //     }
  //   }
  //   // compare all dates and return corresponding videos
  //   List<String> recentDates = _compareDates(videoDates);
  //   List<Video> recentVideos = [];
  //   for (int i = 0; i < recentDates.length; i++) {
  //     for (var id in videoIDs.keys) {
  //       if (videoIDs[id] == recentDates[i]) {
  //         recentVideos.add(await getVideo(id));
  //       }
  //     }
  //   }
  //   return recentVideos;
  // }

  // /// Compares dates from a list of strings
  // /// and returns a list of 5 most recent dates
  // List<String> _compareDates(List<String> dates) {
  //   // date format: dd-mm-yyyy
  //   // change to format: yyyy-dd-mm for DateTime parsing
  //   List<DateTime> parsedDates = dates.map((date) {
  //     List<String> splitDate = date.split('-');
  //     return DateTime.utc(int.parse(splitDate[2]), int.parse(splitDate[1]),
  //         int.parse(splitDate[0]));
  //   }).toList();
  //   parsedDates.sort((a, b) => b.compareTo(a));
  //   List<DateTime> recentParsed = parsedDates.take(8).toList();

  //   //convert back to my format
  //   return recentParsed
  //       .map((date) => '${date.day.toString().padLeft(2, '0')}'
  //           '-${date.month.toString().padLeft(2, '0')}'
  //           '-${date.year}')
  //       .toList();
  // }