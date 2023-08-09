import 'package:firebase_storage/firebase_storage.dart';
import 'package:podcasts_ruben/models/firebase_file.dart';
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

  static Future<List> getPlaylistCardData() async {
    final playlists = await FirestoreService().getPlaylists(); // data base info
    final playlistFiles = await Future.wait(playlists.map(
            (e) async => await getFile(e.img))); // storage images
    return [playlists, playlistFiles.toList()];
  }
}