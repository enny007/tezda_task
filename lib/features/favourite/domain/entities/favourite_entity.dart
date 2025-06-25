class FavoriteEntity {
  final String id;
  final String userId;
  final int productId;
  final DateTime createdAt;

  const FavoriteEntity({
    required this.id,
    required this.userId,
    required this.productId,
    required this.createdAt,
  });

  FavoriteEntity copyWith({
    String? id,
    String? userId,
    int? productId,
    DateTime? createdAt,
  }) {
    return FavoriteEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'FavoriteEntity(id: $id, userId: $userId, productId: $productId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant FavoriteEntity other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.userId == userId &&
      other.productId == productId &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      productId.hashCode ^
      createdAt.hashCode;
  }
}
