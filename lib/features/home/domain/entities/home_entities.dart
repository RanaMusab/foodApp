import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class DishEntity extends Equatable {
  const DishEntity({this.id, this.name, this.description, this.price, this.image});

  final int? id;
  final String? name;
  final String? description;
  final double? price;
  final String? image;

  @override
  List<Object?> get props => [id, name, description, price, image];
}
