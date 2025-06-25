import 'package:tezda_task/features/product/domain/entities/product_entity.dart';
import 'category_model.dart';

class ProductModel {
  final int id;
  final String title;
  final String slug;
  final double price;
  final String description;
  final CategoryModel category;
  final List<String> images;

  const ProductModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      slug: json['slug'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      images: (json['images'] as List<dynamic>)
          .map((image) => image as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'price': price,
      'description': description,
      'category': category.toJson(),
      'images': images,
    };
  }

  // Convert to domain entity
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      title: title,
      slug: slug,
      price: price,
      description: description,
      category: category.toEntity(),
      images: images,
    );
  }

  // Create from domain entity
  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      title: entity.title,
      slug: entity.slug,
      price: entity.price,
      description: entity.description,
      category: CategoryModel.fromEntity(entity.category),
      images: entity.images,
    );
  }

  ProductModel copyWith({
    int? id,
    String? title,
    String? slug,
    double? price,
    String? description,
    CategoryModel? category,
    List<String>? images,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      images: images ?? this.images,
    );
  }
}


