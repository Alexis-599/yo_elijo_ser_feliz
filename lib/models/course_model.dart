class CourseModel {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String price;
  final String image;
  final int videoLength;
  final String videoLink;

  CourseModel({
    required this.id,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.price,
    required this.videoLength,
    required this.videoLink,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'],
      image: json['image'],
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      price: json['price'],
      videoLength: json['videoLength'] ?? 0,
      videoLink: json['videoLink'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'price': price,
      'videoLink': videoLink,
      'videoLength': videoLength,
    };
  }

  CourseModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    String? price,
    String? image,
    int? videoLength,
    String? videoLink,
  }) {
    return CourseModel(
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      price: price ?? this.price,
      videoLength: videoLength ?? this.videoLength,
      videoLink: videoLink ?? this.videoLink,
    );
  }
}
