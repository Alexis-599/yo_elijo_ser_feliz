class PlayListModel {
  final String id;
  final String creatorName;
  final String title;
  final String thumbnail;
  final String creatorDetails;
  final String creatorPic;

  PlayListModel({
    required this.title,
    required this.thumbnail,
    required this.id,
    required this.creatorName,
    required this.creatorDetails,
    required this.creatorPic,
  });

  factory PlayListModel.fromJson(Map<String, dynamic> map) {
    return PlayListModel(
      thumbnail: map['thumbnail'],
      title: map['title'],
      id: map['id'],
      creatorName: map['creatorName'],
      creatorDetails: map['creatorDetails'],
      creatorPic: map['creatorPic'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'creatorName': creatorName,
      'creatorDetails': creatorDetails,
      'creatorPic': creatorPic,
    };
  }

  PlayListModel copyWith({
    String? id,
    String? creatorName,
    String? creatorDetails,
    String? creatorPic,
    String? thumbnail,
    String? title,
  }) {
    return PlayListModel(
      id: id ?? this.id,
      title: title ?? this.title,
      thumbnail: thumbnail ?? this.thumbnail,
      creatorName: creatorName ?? this.creatorName,
      creatorDetails: creatorDetails ?? this.creatorName,
      creatorPic: creatorPic ?? this.creatorPic,
    );
  }
}
