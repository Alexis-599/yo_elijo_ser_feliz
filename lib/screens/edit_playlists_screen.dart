import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcasts_ruben/models/playlist_model.dart';
import 'package:podcasts_ruben/screens/add_playlist.dart';
import 'package:podcasts_ruben/services/firebase_api.dart';
import 'package:podcasts_ruben/widgets/playlist_card.dart';
import 'package:provider/provider.dart';

class EditPlaylistsScreen extends StatefulWidget {
  const EditPlaylistsScreen({super.key});

  @override
  State<EditPlaylistsScreen> createState() => _EditPlaylistsScreenState();
}

class _EditPlaylistsScreenState extends State<EditPlaylistsScreen> {
  // late Future<List<dynamic>> playlistMedia;

  @override
  void initState() {
    super.initState();
    // playlistMedia = FirebaseApi.getPlaylistMedia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                Get.to(() => const AddPlaylist());
              }, // add playlist
              icon: const Icon(
                Icons.add_box,
                color: Colors.white,
              ),
              iconSize: 40,
            ),
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Colors.amber.shade300,
                Colors.amber.shade100,
              ])),
          child: StreamProvider.value(
            value: FirebaseApi.getPlaylists(''),
            initialData: null,
            catchError: (context, error) => null,
            child: Consumer<List<PlayListModel>?>(
                builder: (context, playlists, b) {
              if (playlists == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: playlists.length,
                padding: const EdgeInsets.all(20),
                itemBuilder: (c, i) {
                  return P2Card(
                    playlist: playlists[i],
                    isEditScreen: true,
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
