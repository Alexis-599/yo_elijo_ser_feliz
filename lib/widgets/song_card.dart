import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/song_model.dart';

class SongCard extends StatelessWidget {
  const SongCard({
    super.key,
    required this.song,
  });

  final Song song;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed('/song', arguments: song);
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image(
              image: AssetImage(song.coverUrl),
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            song.title,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
          ),
          Text(
            song.description,
            style: Theme.of(context).textTheme.bodySmall!,
          ),
        ],
      ),
    );
  }
}

// Container(
// margin: const EdgeInsets.only(right: 10),
// width: MediaQuery.of(context).size.width * 0.45,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(15),
// image: DecorationImage(
// image: AssetImage(song.coverUrl),
// fit: BoxFit.cover,
// ),
// ),
// )