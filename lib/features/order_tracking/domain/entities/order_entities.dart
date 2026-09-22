import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:food_app/features/order_tracking/domain/entities/order_status.dart';

@immutable
class GeoPoint extends Equatable {
  const GeoPoint(this.latitude, this.longitude);

  final double latitude;
  final double longitude;

  factory GeoPoint.fromJson(Map<String, dynamic> json) => GeoPoint(
    (json['lat'] as num).toDouble(),
    (json['lng'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {'lat': latitude, 'lng': longitude};

  @override
  List<Object?> get props => [latitude, longitude];
}

@immutable
abstract class OrderEntity extends Equatable {
  const OrderEntity({
    this.id,
    this.restaurantName,
    this.status = OrderStatus.orderPlaced,
    this.restaurant,
    this.destination,
    this.riderLocation,
    this.riderName,
    this.etaMinutes,
  });

  final String? id;
  final String? restaurantName;
  final OrderStatus status;
  final GeoPoint? restaurant;
  final GeoPoint? destination;

  /// Null until the rider picks the order up.
  final GeoPoint? riderLocation;
  final String? riderName;
  final int? etaMinutes;

  @override
  List<Object?> get props => [
    id,
    restaurantName,
    status,
    restaurant,
    destination,
    riderLocation,
    riderName,
    etaMinutes,
  ];
}
