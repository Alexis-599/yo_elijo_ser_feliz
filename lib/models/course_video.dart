class CourseVideo {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final String thumbnail;
  final String date;
  final String link;
  final String aspectRatio;

  CourseVideo({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.date,
    required this.link,
    required this.aspectRatio,
  });

  factory CourseVideo.fromJson(Map<String, dynamic> json) {
    return CourseVideo(
      id: json['id'],
      courseId: json['courseId'],
      title: json['title'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      date: json['date'],
      link: json['link'],
      aspectRatio: json['aspectRatio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'date': date,
      'link': link,
      'aspectRatio': aspectRatio,
    };
  }

  CourseVideo copyWith({
    String? id,
    String? title,
    String? courseId,
    String? description,
    String? thumbnail,
    String? date,
    String? link,
    String? aspectRatio,
  }) {
    return CourseVideo(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
      date: date ?? this.date,
      link: link ?? this.link,
      aspectRatio: aspectRatio ?? this.aspectRatio,
    );
  }
}
