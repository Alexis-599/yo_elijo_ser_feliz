import 'package:podcasts_ruben/services/models.dart';

class CourseModel {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String price;
  final String image;
  final List<Video> courseVideos;

  CourseModel({
    required this.id,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.price,
    required this.courseVideos,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'],
      image: json['image'],
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      price: json['price'],
      courseVideos: json['courseVideos'] ?? <Video>[],
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
      'courseVideos': courseVideos,
    };
  }
}
