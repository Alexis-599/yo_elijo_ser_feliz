import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:podcasts_ruben/models/playlist_model.dart';
import 'package:podcasts_ruben/models/youtube_playlist_model.dart';
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
  late TextEditingController titleController;
  String? authorImage;
  String? thumbnail;

  bool isLoading = false;

  getAuthorImage() async {
    var file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        authorImage = file.path;
      });
    }
  }

  getThumbnailImage() async {
    var file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        thumbnail = file.path;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    nameController =
        TextEditingController(text: widget.playlistModel.creatorName);
    descriptionController =
        TextEditingController(text: widget.playlistModel.creatorDetails);
    titleController = TextEditingController(text: widget.playlistModel.title);
  }

  editPlaylist() async {
    setState(() {
      isLoading = true;
    });
    final playList = widget.playlistModel.copyWith(
      creatorName: nameController.text.trim(),
      creatorDetails: descriptionController.text.trim(),
      title: titleController.text.trim(),
      creatorPic: authorImage ?? widget.playlistModel.creatorPic,
      thumbnail: thumbnail ?? widget.playlistModel.thumbnail,
    );
    await FirestoreService().editPlayList(playList).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
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
        centerTitle: true,
        title: const Text(
          'Editar lista de reproducción',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Get.off(() => const AddPlaylist());
      //   },
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      //   backgroundColor: Colors.white,
      //   child: const Icon(Icons.add, size: 40, color: Colors.black87),
      // ),
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
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: thumbnail == null
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(
                                    widget.playlistModel.thumbnail),
                                fit: BoxFit.cover,
                              )
                            : DecorationImage(
                                image: FileImage(File(thumbnail!)),
                                fit: BoxFit.cover,
                              ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () => getThumbnailImage(),
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
                    label: 'Título',
                    text: widget.playlistModel.title,
                    onChanged: (v) {},
                    controller: titleController,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Container(
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: authorImage == null
                              ? DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      widget.playlistModel.creatorPic),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image: FileImage(File(authorImage!)),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: () => getAuthorImage(),
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
                      const SizedBox(width: 15),
                      Expanded(
                        flex: 7,
                        child: Column(
                          children: [
                            EditTextField(
                              label: 'Nombre',
                              text: widget.playlistModel.creatorName,
                              onChanged: (v) {},
                              controller: nameController,
                            ),
                            const SizedBox(height: 15),
                            EditTextField(
                              label: 'Detalle',
                              text: widget.playlistModel.creatorDetails,
                              onChanged: (v) {},
                              controller: descriptionController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  MyButton(
                    onTap: () => editPlaylist(),
                    text: 'Ahorrar',
                    isLoading: isLoading,
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
