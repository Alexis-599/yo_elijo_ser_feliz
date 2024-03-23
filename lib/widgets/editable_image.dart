import 'package:flutter/material.dart';

class EditableImage extends StatelessWidget {
  const EditableImage({
    super.key,
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
            Center(
              child: ClipRRect(
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
