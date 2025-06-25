// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.createdAt,
  });

  

  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, name: $name, photoUrl: $photoUrl, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant UserEntity other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.email == email &&
      other.name == name &&
      other.photoUrl == photoUrl &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      email.hashCode ^
      name.hashCode ^
      photoUrl.hashCode ^
      createdAt.hashCode;
  }
}
