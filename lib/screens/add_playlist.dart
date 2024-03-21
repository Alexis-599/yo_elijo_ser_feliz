import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:podcasts_ruben/models/playlist_model.dart';
import 'package:podcasts_ruben/services/firestore.dart';
import 'package:podcasts_ruben/widgets/edit_text_field.dart';
import 'package:podcasts_ruben/widgets/my_button.dart';

class AddPlaylist extends StatefulWidget {
  const AddPlaylist({super.key});

  @override
  State<AddPlaylist> createState() => _AddPlaylistState();
}

class _AddPlaylistState extends State<AddPlaylist> {
  final urlController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  String? image;

  getImage() async {
    var file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      image = file.path;
      setState(() {});
    }
  }

  createPlaylist() {
    final playList = PlayListModel(
      id: getPlaylistIdFromUrl(urlController.text),
      creatorName: nameController.text.trim(),
      creatorDetails: descriptionController.text.trim(),
      creatorPic: image!,
    );
    FirestoreService().postNewPlayList(playList);
    setState(() {
      urlController.clear();
      nameController.clear();
      image = null;
      descriptionController.clear();
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
                      image: image == null
                          ? null
                          : DecorationImage(
                              image: FileImage(
                                File(image!),
                              ),
                              fit: BoxFit.cover,
                            ),
                    ),
                    child: image == null
                        ? _EditableImage(
                            isAuthor: true,
                            size: MediaQuery.of(context).size.height * 0.17,
                            onTap: () => getImage(),
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
                isLoading: false,
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

class _EditableImage extends StatelessWidget {
  const _EditableImage({
    this.isAuthor = false,
    required this.size,
    required this.onTap,
  });

  // final FirebaseFile? playlistFile;
  final double size;
  final Function()? onTap;
  final bool isAuthor;

  @override
  Widget build(BuildContext context) {
    double editSquareSize = size * 0.2;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: isAuthor
            ? BoxDecoration(
                border: Border.all(
                  color: Colors.black12,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(19),
              )
            : null,
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image(
                image: isAuthor
                    ? const AssetImage('assets/images/author.png')
                    : const AssetImage('assets/images/podcast.png'),
                height: size,
                width: size,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: editSquareSize,
              height: editSquareSize,
              decoration: ShapeDecoration(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                  ),
                ),
                color: Colors.black.withOpacity(0.5),
              ),
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: editSquareSize * 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
