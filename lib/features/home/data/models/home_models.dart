import 'package:food_app/features/home/domain/entities/home_entities.dart';

class Dish extends DishEntity {
  const Dish({
    super.id,
    super.name,
    super.description,
    super.price,
    super.image,
  });

  factory Dish.fromJson(Map<String, dynamic> json) => Dish(
    id: json['id'] as int?,
    name: json['name'] as String?,
    description: json['description'] as String?,
    price: (json['price'] as num?)?.toDouble(),
    image: json['image'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'image': image,
  };
}
