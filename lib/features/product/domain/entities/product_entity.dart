import 'category_entity.dart';

class ProductEntity {
  final int id;
  final String title;
  final String slug;
  final double price;
  final String description;
  final CategoryEntity category;
  final List<String> images;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
  });

  ProductEntity copyWith({
    int? id,
    String? title,
    String? slug,
    double? price,
    String? description,
    CategoryEntity? category,
    List<String>? images,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      images: images ?? this.images,
    );
  }

  @override
  String toString() {
    return 'ProductEntity(id: $id, title: $title, slug: $slug, price: $price, description: $description, category: $category, images: $images)';
  }

  @override
  bool operator ==(covariant ProductEntity other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.slug == slug &&
      other.price == price &&
      other.description == description &&
      other.category == category &&
      _listEquals(other.images, images);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      slug.hashCode ^
      price.hashCode ^
      description.hashCode ^
      category.hashCode ^
      images.hashCode;
  }

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
