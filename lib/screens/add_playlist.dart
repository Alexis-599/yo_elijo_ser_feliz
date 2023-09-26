import 'package:flutter/material.dart';
import 'package:podcasts_ruben/services/firebase_file.dart';
import 'package:podcasts_ruben/widgets/edit_text_field.dart';
import 'package:podcasts_ruben/widgets/my_button.dart';

class AddPlaylist extends StatelessWidget {
  const AddPlaylist({super.key});

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
              _EditableImage(
                onTap: () {},
                size: MediaQuery.of(context).size.height * 0.3,
              ),
              const SizedBox(height: 8),
              EditTextField(
                label: 'Título',
                text: '',
                onChanged: (change) {},
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  _EditableImage(
                    isAuthor: true,
                    size: MediaQuery.of(context).size.height * 0.17,
                    onTap: () {},
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: EditTextField(
                        label: 'Nombre',
                        text: '',
                        onChanged: (change) {},
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 18),
              EditTextField(
                label: 'Descripción',
                text: '',
                onChanged: (change) {},
                maxLines: 4,
              ),
              const SizedBox(height: 18),
              MyButton(
                onTap: () {},
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

class _EditableImage extends StatelessWidget {
  const _EditableImage({
    this.playlistFile,
    this.isAuthor = false,
    required this.size,
    required this.onTap,
  });

  final FirebaseFile? playlistFile;
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
