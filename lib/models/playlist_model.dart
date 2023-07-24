import 'song_model.dart';

class Playlist {
  final String title;
  final List<Song> songs;
  final String imageUrl;
  final String authorImageUrl;

  Playlist({
    required this.title,
    required this.songs,
    required this.imageUrl,
    required this.authorImageUrl,
  });

  static List<Playlist> playlists = [
    Playlist(
      title: 'Mujer, madre y amante',
      songs: Song.songs,
      imageUrl: 'assets/images/yo_elijo_ser_feliz.jpg',
      authorImageUrl: 'assets/images/adriana_carreon.jpg',
    ),
    Playlist(
      title: 'Espiritualidad día a día',
      songs: Song.songs,
      imageUrl: 'assets/images/yo_elijo_ser_feliz.jpg',
      authorImageUrl: 'assets/images/ruben_carreon.jpg',
    ),
    Playlist(
      title: 'Rituales Lulú Kuri',
      songs: Song.songs,
      imageUrl: 'assets/images/yo_elijo_ser_feliz.jpg',
      authorImageUrl: 'assets/images/yo_elijo_ser_feliz.jpg',
    ),
  ];
}
