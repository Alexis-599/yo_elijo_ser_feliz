import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:podcasts_ruben/models/playlist_model.dart';
import 'package:podcasts_ruben/models/youtube_playlist_model.dart';
import 'package:podcasts_ruben/screens/add_playlist.dart';
import 'package:podcasts_ruben/services/firestore.dart';
import 'package:podcasts_ruben/widgets/edit_text_field.dart';
import 'package:podcasts_ruben/widgets/my_button.dart';

class EditablePlaylistScreen extends StatefulWidget {
  const EditablePlaylistScreen({
    super.key,
    required this.playlist,
    required this.playlistModel,
  });

  final PlayListModel playlistModel;
  final YouTubePlaylist playlist;

  @override
  State<EditablePlaylistScreen> createState() => _EditablePlaylistScreenState();
}

class _EditablePlaylistScreenState extends State<EditablePlaylistScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late String image;

  getImage() async {
    var file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      image = file.path;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    nameController =
        TextEditingController(text: widget.playlistModel.creatorName);
    descriptionController =
        TextEditingController(text: widget.playlistModel.creatorDetails);
    image = widget.playlistModel.creatorPic;
  }

  editPlaylist() {
    final playList = widget.playlistModel.copyWith(
      creatorName: nameController.text.trim(),
      creatorDetails: descriptionController.text.trim(),
      creatorPic: image,
    );
    FirestoreService().editPlayList(playList);
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
            margin: const EdgeInsets.only(right: 10, top: 10),
            child: const Icon(Icons.search, size: 30),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.off(() => const AddPlaylist());
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, size: 40, color: Colors.black87),
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
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      height: 250,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: image.contains('http')
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(image),
                                fit: BoxFit.cover,
                              )
                            : DecorationImage(
                                image: FileImage(File(image)),
                                fit: BoxFit.cover,
                              ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () => getImage(),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  EditTextField(
                    label: 'Name',
                    text: widget.playlistModel.creatorName,
                    onChanged: (v) {},
                    controller: nameController,
                  ),
                  const SizedBox(height: 15),
                  EditTextField(
                    label: 'Detail',
                    text: widget.playlistModel.creatorName,
                    onChanged: (v) {},
                    controller: descriptionController,
                  ),
                  const SizedBox(height: 15),
                  MyButton(
                    onTap: () => editPlaylist(),
                    text: 'Save',
                    isLoading: false,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
