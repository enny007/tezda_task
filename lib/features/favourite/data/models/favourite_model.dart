import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tezda_task/features/favourite/domain/entities/favourite_entity.dart';

class FavoriteModel {
  final String id;
  final String userId;
  final int productId;
  final DateTime createdAt;

  const FavoriteModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.createdAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      productId: json['productId'] as int,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  FavoriteEntity toEntity() {
    return FavoriteEntity(
      id: id,
      userId: userId,
      productId: productId,
      createdAt: createdAt,
    );
  }

  factory FavoriteModel.fromEntity(FavoriteEntity entity) {
    return FavoriteModel(
      id: entity.id,
      userId: entity.userId,
      productId: entity.productId,
      createdAt: entity.createdAt,
    );
  }
}
