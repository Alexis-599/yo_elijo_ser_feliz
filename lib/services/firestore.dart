import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:podcasts_ruben/services/auth.dart';
import 'package:podcasts_ruben/services/models.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
    var ref = _db.collection('quizzes').doc(videoId);
    var snapshot = await ref.get();
    return Video.fromJson(snapshot.data() ?? {});
  }

}