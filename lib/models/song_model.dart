class Song {
  final String title;
  final String description;
  final String url;
  final String coverUrl;
  final String releaseDate;

  Song({
    required this.title,
    required this.description,
    required this.url,
    required this.coverUrl,
    required this.releaseDate,
  });

  // static List<Song> songs = [
  //   Song(
  //     title: 'Mujer, madre y amante',
  //     description: 'El placer de dar',
  //     url: 'assets/music/mma_el_placer_de_dar.mp3',
  //     coverUrl: 'assets/images/yo_elijo_ser_feliz.jpg',
  //     releaseDate: '4, Julio - 2023',
  //   ),
  //   Song(
  //     title: 'Rituales Lulú Kuri',
  //     description: 'Ritual de luna llena',
  //     url: 'assets/music/rlk_ritual_de_la_luna_llena.mp3',
  //     coverUrl: 'assets/images/yo_elijo_ser_feliz.jpg',
  //     releaseDate: '4, Julio - 2023',
  //   ),
  //   Song(
  //     title: 'Espiritualidad día a día',
  //     description: 'Vive tu vida al máximo',
  //     url: 'assets/music/edad_vive_tu_vida_al_maximo.mp3',
  //     coverUrl: 'assets/images/yo_elijo_ser_feliz.jpg',
  //     releaseDate: '4, Julio - 2023',
  //   ),
  // ];
}
