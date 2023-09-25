class ShopTypeModel {
  final String? id;
  final String? name;
  final String? description;
  final bool? isActive;

  ShopTypeModel({
    this.id,
    this.name,
    this.description,
    this.isActive,
  });

  factory ShopTypeModel.fromJson(Map<String, dynamic> json) {
    return ShopTypeModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isActive: json['is_active'],
    );
  }
}
