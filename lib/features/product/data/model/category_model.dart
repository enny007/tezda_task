import 'package:tezda_task/features/product/domain/entities/category_entity.dart';

class CategoryModel {
  final int id;
  final String name;
  final String image;
  final String slug;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.slug,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      slug: json['slug'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'slug': slug,
    };
  }

  // Convert to domain entity
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      image: image,
      slug: slug,
    );
  }

  // Create from domain entity
  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      image: entity.image,
      slug: entity.slug,
    );
  }

  CategoryModel copyWith({
    int? id,
    String? name,
    String? image,
    String? slug,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      slug: slug ?? this.slug,
    );
  }
}
