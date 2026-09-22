import 'package:food_app/features/order_tracking/domain/entities/order_entities.dart';
import 'package:food_app/features/order_tracking/domain/entities/order_status.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    super.id,
    super.restaurantName,
    super.status,
    super.restaurant,
    super.destination,
    super.riderLocation,
    super.riderName,
    super.etaMinutes,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json['id']?.toString(),
    restaurantName: json['restaurant_name'] as String?,
    status: OrderStatus.fromKey(json['status'] as String?),
    restaurant: json['restaurant'] != null
        ? GeoPoint.fromJson(json['restaurant'] as Map<String, dynamic>)
        : null,
    destination: json['destination'] != null
        ? GeoPoint.fromJson(json['destination'] as Map<String, dynamic>)
        : null,
    riderLocation: json['rider_location'] != null
        ? GeoPoint.fromJson(json['rider_location'] as Map<String, dynamic>)
        : null,
    riderName: json['rider_name'] as String?,
    etaMinutes: (json['eta_minutes'] as num?)?.toInt(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'restaurant_name': restaurantName,
    'status': status.key,
    'restaurant': restaurant?.toJson(),
    'destination': destination?.toJson(),
    'rider_location': riderLocation?.toJson(),
    'rider_name': riderName,
    'eta_minutes': etaMinutes,
  };

  OrderModel copyWith({
    OrderStatus? status,
    GeoPoint? riderLocation,
    int? etaMinutes,
  }) => OrderModel(
    id: id,
    restaurantName: restaurantName,
    status: status ?? this.status,
    restaurant: restaurant,
    destination: destination,
    riderLocation: riderLocation ?? this.riderLocation,
    riderName: riderName,
    etaMinutes: etaMinutes ?? this.etaMinutes,
  );
}
