import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcasts_ruben/data.dart';
import 'package:podcasts_ruben/models/playlist_model.dart';
import 'package:podcasts_ruben/screens/edit_playlists_screen.dart';
import 'package:podcasts_ruben/services/firebase_api.dart';
import 'package:podcasts_ruben/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AllPlaylists extends StatefulWidget {
  const AllPlaylists({super.key});

  @override
  State<AllPlaylists> createState() => _AllPlaylistsState();
}

class _AllPlaylistsState extends State<AllPlaylists> {
  AppData appData = AppData();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade800.withOpacity(1),
            Colors.amber.shade400.withOpacity(1),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    appData.isAdmin
                        ? IconButton(
                            onPressed: () {
                              Get.to(() => const EditPlaylistsScreen());
                            },
                            icon: const Icon(Icons.add_box),
                            iconSize: 55,
                            color: Colors.white,
                          )
                        : const SizedBox.shrink(),
                    Flexible(
                      child: TextFormField(
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Buscar',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.grey.shade500),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade500,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                StreamProvider.value(
                  value: FirebaseApi.getPlaylists(),
                  initialData: null,
                  catchError: (context, error) => null,
                  child: Consumer<List<PlayListModel>?>(
                    builder: (context, playlists, b) {
                      if (playlists == null) {
                        return const CircularProgressIndicator();
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemCount: playlists.length,
                          itemBuilder: (c, i) {
                            return P2Card(
                              playlist: playlists[i],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
