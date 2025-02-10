
class ProductCustomizationEntity{
  String categoryId;
  List<OptionDataEntity> optionData;
  ProductCustomizationEntity({required this.categoryId, required this.optionData});
}

class OptionDataEntity{
  String type ;
  List<OptionsEntity> options;
  OptionDataEntity({required this.type, required this.options});
}

class OptionsEntity {
  final String name;
  final double price;
  final bool isVeg;

  OptionsEntity({required this.name, required this.price, required this.isVeg});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OptionsEntity) return false;
    return name == other.name && price == other.price && isVeg == other.isVeg;
  }

  @override
  int get hashCode => Object.hash(name, price, isVeg);
}
