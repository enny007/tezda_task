class CategoryEntity {
  final int id;
  final String name;
  final String image;
  final String slug;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.slug,
  });

  CategoryEntity copyWith({
    int? id,
    String? name,
    String? image,
    String? slug,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      slug: slug ?? this.slug,
    );
  }

  @override
  String toString() {
    return 'CategoryEntity(id: $id, name: $name, image: $image, slug: $slug)';
  }

  @override
  bool operator ==(covariant CategoryEntity other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.image == image &&
      other.slug == slug;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      image.hashCode ^
      slug.hashCode;
  }
}
