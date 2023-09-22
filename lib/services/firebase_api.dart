import 'package:firebase_storage/firebase_storage.dart';
import 'package:podcasts_ruben/services/firebase_file.dart';
import 'package:podcasts_ruben/services/models.dart';
import 'package:podcasts_ruben/services/firestore.dart';

class FirebaseApi {
  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
    Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<FirebaseFile> getFile(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final name = ref.name;
    final url = await ref.getDownloadURL();
    return FirebaseFile(ref: ref, name: name, url: url);
  }

  static Future<List<FirebaseFile>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();
    final urls = await _getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;
          final file = FirebaseFile(ref: ref, name: name, url: url);

          return MapEntry(index, file);
        })
        .values
        .toList();
  }

  static Future<List> getPlaylistMedia() async {
    final playlists = await FirestoreService().getPlaylists(); // data base info
    final playlistImg = await Future.wait(playlists.map(
            (e) async => await getFile(e.img)));
    final playlistAuthorImg = await Future.wait(playlists.map(
            (e) async => await getFile(e.authorImg))); // change to e.authorImg
    return [playlists, playlistImg.toList(), playlistAuthorImg.toList()];
  }

  static Future<List> getVideosMediaFromPlaylist(Playlist playlist, int chunk, int limit) async {
    final videos = await FirestoreService().getVideosFromPlaylist(
        playlist,
        chunk,
        limit
    );
    return getVideosMedia(videos);
  }

  static Future<List> getRecentVideosMedia() async {
    final videos = await FirestoreService().getRecentVideos();
    return getVideosMedia(videos);
  }

  static Future<List> getVideosMedia(List<Video> videos) async {
    final videoImg = await Future.wait(videos.map(
            (e) async => await getFile(e.img)));
    final videoAudio = await Future.wait(videos.map(
            (e) async => await getFile(e.path)));
    return [videos, videoImg.toList(), videoAudio.toList()];
  }
}