class PlayListModel {
  final String id;
  final String creatorName;
  final String creatorDetails;
  final String creatorPic;

  PlayListModel({
    required this.id,
    required this.creatorName,
    required this.creatorDetails,
    required this.creatorPic,
  });

  factory PlayListModel.fromJson(Map<String, dynamic> map) {
    return PlayListModel(
      id: map['id'],
      creatorName: map['creatorName'],
      creatorDetails: map['creatorDetails'],
      creatorPic: map['creatorPic'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
  }) {
    return PlayListModel(
      id: id ?? this.id,
      creatorName: creatorName ?? this.creatorName,
      creatorDetails: creatorDetails ?? this.creatorName,
      creatorPic: creatorPic ?? this.creatorPic,
    );
  }
}
