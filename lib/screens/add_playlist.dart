import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:podcasts_ruben/models/playlist_model.dart';
import 'package:podcasts_ruben/services/firestore.dart';
import 'package:podcasts_ruben/widgets/edit_text_field.dart';
import 'package:podcasts_ruben/widgets/editable_image.dart';
import 'package:podcasts_ruben/widgets/my_button.dart';

class AddPlaylist extends StatefulWidget {
  const AddPlaylist({super.key});

  @override
  State<AddPlaylist> createState() => _AddPlaylistState();
}

class _AddPlaylistState extends State<AddPlaylist> {
  final urlController = TextEditingController();
  final nameController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String? autherImage;
  String? thumbnail;

  bool isLoading = false;

  getThumbnail() async {
    var file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      thumbnail = file.path;
      setState(() {});
    }
  }

  getAuthorImage() async {
    var file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      autherImage = file.path;
      setState(() {});
    }
  }

  createPlaylist() async {
    setState(() {
      isLoading = true;
    });
    final playList = PlayListModel(
      id: getPlaylistIdFromUrl(
          'https://www.youtube.com/playlist?list=PLDsYoS8mDh36n7K_v4rA36Gq_TzArKy58'),
      creatorName: nameController.text.trim(),
      creatorDetails: descriptionController.text.trim(),
      creatorPic: autherImage!,
      thumbnail: thumbnail!,
      title: titleController.text.trim(),
    );
    await FirestoreService().postNewPlayList(playList).whenComplete(() {
      Fluttertoast.showToast(msg: 'Playlist upload successfully');
      setState(() {
        urlController.clear();
        nameController.clear();
        titleController.clear();
        autherImage = null;
        thumbnail = null;
        descriptionController.clear();
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(19),
                  image: thumbnail == null
                      ? null
                      : DecorationImage(
                          image: FileImage(
                            File(thumbnail!),
                          ),
                          fit: BoxFit.cover,
                        ),
                ),
                child: thumbnail == null
                    ? EditableImage(
                        isAuthor: true,
                        size: MediaQuery.of(context).size.height * 0.2,
                        onTap: () => getThumbnail(),
                      )
                    : const SizedBox(
                        width: 0,
                      ),
              ),
              const SizedBox(height: 18),
              EditTextField(
                controller: titleController,
                label: 'Title',
                text: '',
                onChanged: (change) {},
              ),
              const SizedBox(height: 18),
              EditTextField(
                controller: urlController,
                label: 'Playlist URL',
                text: '',
                onChanged: (change) {},
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.17,
                    width: MediaQuery.of(context).size.height * 0.17,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19),
                      image: autherImage == null
                          ? null
                          : DecorationImage(
                              image: FileImage(
                                File(autherImage!),
                              ),
                              fit: BoxFit.cover,
                            ),
                    ),
                    child: autherImage == null
                        ? EditableImage(
                            isAuthor: true,
                            size: MediaQuery.of(context).size.height * 0.17,
                            onTap: () => getAuthorImage(),
                          )
                        : const SizedBox(
                            width: 0,
                          ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: EditTextField(
                            controller: nameController,
                            label: 'Nombre',
                            text: '',
                            onChanged: (change) {},
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, top: 10),
                          child: EditTextField(
                            controller: descriptionController,
                            label: 'Descripción',
                            text: '',
                            onChanged: (change) {},
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 18),
              MyButton(
                onTap: () => createPlaylist(),
                text: 'Crear playlist',
                isLoading: isLoading,
              )
            ],
          ),
        ),
      ),
    );
  }
}

String getPlaylistIdFromUrl(String url) {
  return url.trim().split('=').last;
}
