class UserModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final String? imageUrl;
  final bool isAdmin;
  final List<String>? coursesIds;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.imageUrl,
    required this.isAdmin,
    required this.coursesIds,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      imageUrl: map['imageUrl'],
      isAdmin: map['isAdmin'] ?? false,
      coursesIds: map['coursesIds'] ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'imageUrl': imageUrl,
      'isAdmin': isAdmin,
      'coursesIds': coursesIds,
    };
  }
}
