class CategoryEntity {
  String categoryId;
  String categoryName;
  String description;
  String imageUrl;
  bool isNonVeg;
  bool isVeg;

  CategoryEntity({
    required this.categoryId,
    required this.categoryName,
    required this.description,
    required this.imageUrl,
    required this.isNonVeg,
    required this.isVeg,
  });

  Map<String, dynamic> toJson() {
    return {
      "category_id": categoryId,
      "category_name": categoryName,
      "description": description,
      "imageUrl": imageUrl,
      "isNonVeg": isNonVeg,
      "isVeg": isVeg,
    };
  }

  @override
  String toString() {
    return 'CategoryEntity{categoryId: $categoryId, categoryName: $categoryName, description: $description, imageUrl: $imageUrl, isNonVeg: $isNonVeg, isVeg: $isVeg}';
  }
}
