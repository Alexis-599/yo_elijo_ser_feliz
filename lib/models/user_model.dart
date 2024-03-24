class UserModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final String? imageUrl;
  final bool isAdmin;
  final List? coursesIds;

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

  UserModel copyWith({
    String? id,
    String? name,
    String? username,
    String? email,
    String? imageUrl,
    bool? isAdmin,
    List? coursesIds,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      isAdmin: isAdmin ?? this.isAdmin,
      coursesIds: coursesIds ?? this.coursesIds,
    );
  }
}
