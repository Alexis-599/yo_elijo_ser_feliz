import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcasts_ruben/data.dart';
import 'package:podcasts_ruben/models/course_video.dart';
import 'package:podcasts_ruben/models/playlist_model.dart';
import 'package:podcasts_ruben/models/user_model.dart';
import 'package:podcasts_ruben/screens/edit_course_video.dart';
import 'package:podcasts_ruben/screens/editable_playlist_screen.dart';
import 'package:podcasts_ruben/screens/playlist_screen.dart';
import 'package:podcasts_ruben/services/firestore.dart';
import 'package:podcasts_ruben/widgets/alert_dialog.dart';
import 'package:podcasts_ruben/widgets/widget_shimmer.dart';
import 'package:provider/provider.dart';

class P2Card extends StatelessWidget {
  const P2Card({
    super.key,
    required this.playlist,
    this.isEditScreen = false,
  });

  final PlayListModel playlist;
  final bool isEditScreen;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AppData().fetchPlaylistDetails(playlist.id),
      builder: (c, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 5),
              leading: ShimmerWidget.circular(
                height: 75,
                width: 100,
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              title: ShimmerWidget.rectangular(height: 10, width: 100),
              subtitle: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: ShimmerWidget.rectangular(height: 5, width: 50),
              ),
            ),
          );
        } else if (snap.hasError) {
          return Center(
            child: Text(snap.error.toString()),
          );
        } else if (snap.hasData && snap.data != null) {
          final youtubePlaylist = snap.data!;
          return ListTile(
            onTap: () => Get.to(() => isEditScreen
                ? EditablePlaylistScreen(
                    playlist: youtubePlaylist, playlistModel: playlist)
                : PlaylistScreen(
                    playlist: youtubePlaylist,
                    playlistModel: playlist,
                  )),
            visualDensity: const VisualDensity(vertical: 4, horizontal: 4),
            horizontalTitleGap: 10,
            title: Text(
              playlist.title,
              maxLines: 2,
              style: const TextStyle(
                color: Colors.black,
                overflow: TextOverflow.ellipsis,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            leading: Container(
              height: 75,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(playlist.thumbnail),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            subtitle: Text(
              "${youtubePlaylist.itemCount} episodios",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            trailing: isEditScreen
                ? GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => CustomAdaptiveAlertDialog(
                          alertMsg:
                              '¿Estás seguro de que quieres eliminar esta lista de reproducción de tu aplicación?',
                          actiionBtnName: 'Sí',
                          onAction: () {
                            FirestoreService()
                                .deletePlayList(playlist.id)
                                .whenComplete(() {});
                            Get.back();
                          },
                        ),
                      );
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.grey.shade700,
                      size: 25,
                    ),
                  )
                : const Icon(
                    Icons.play_circle_fill_outlined,
                    color: Colors.white,
                    size: 35,
                  ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class P2CardCourseVideo extends StatelessWidget {
  const P2CardCourseVideo({
    super.key,
    required this.course,
    this.isEditScreen = false,
    required this.ontap,
  });

  final CourseVideo course;
  final bool isEditScreen;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: ontap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: course.thumbnail,
          height: 75,
          width: 100,
          fit: BoxFit.cover,
        ),
      ),
      visualDensity: const VisualDensity(vertical: 4),
      contentPadding: EdgeInsets.zero,
      title: Text(
        course.title,
        maxLines: 1,
        style: const TextStyle(
          overflow: TextOverflow.ellipsis,
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        course.description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.grey.shade900,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: context.watch<UserModel>().isAdmin
          ? PopupMenuButton(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                height: 36,
                width: 48,
                alignment: Alignment.centerRight,
                child: const Icon(
                  Icons.more_vert,
                ),
              ),
              itemBuilder: (c) {
                return [
                  PopupMenuItem(
                    child: const Text('Editar detalles del vídeo'),
                    onTap: () {
                      Get.to(() => EditCourseVideo(courseVideo: course));
                    },
                  ),
                  PopupMenuItem(
                    child: const Text(
                      'Eliminar vídeo',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (_) => CustomAdaptiveAlertDialog(
                                alertMsg:
                                    '¿Estás seguro de que quieres eliminar este vídeo?',
                                actiionBtnName: 'Sí',
                                onAction: () async {
                                  await FirestoreService()
                                      .deleteCourseVideo(course);
                                  Get.back();
                                },
                              ));
                    },
                  ),
                ];
              },
            )
          : const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Icon(
                Icons.play_circle_fill,
                size: 35,
              ),
            ),
    );
  }
}
