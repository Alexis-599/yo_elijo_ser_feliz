class CourseModel {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String price;
  final String image;

  CourseModel({
    required this.id,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.price,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'],
      image: json['image'],
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson(CourseModel model) {
    return {
      'id': id,
      'image': image,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'price': price,
    };
  }

  CourseModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    String? price,
    String? image,
  }) {
    return CourseModel(
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      price: price ?? this.price,
    );
  }
}
