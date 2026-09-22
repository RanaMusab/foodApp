import 'dart:async';
import 'dart:math' as math;

import 'package:food_app/base/base_response.dart';
import 'package:food_app/features/order_tracking/data/data_sources/order_tracking_data_sources.dart';
import 'package:food_app/features/order_tracking/data/models/order_models.dart';
import 'package:food_app/features/order_tracking/domain/entities/order_entities.dart';
import 'package:food_app/features/order_tracking/domain/entities/order_status.dart';
import 'package:food_app/features/order_tracking/domain/entities/params/get_order_request_params.dart';
import 'package:food_app/services/hive_service.dart';

class SimulatedOrderDataSource extends OrderTrackingDataSources {
  SimulatedOrderDataSource({
    this.secondsPerStatus = 12,
    this.tick = const Duration(seconds: 1),
  });

  final int secondsPerStatus;
  final Duration tick;

  static const GeoPoint _restaurant = GeoPoint(37.78825, -122.4324);
  static const GeoPoint _destination = GeoPoint(37.7599, -122.4148);

  StreamController<OrderModel>? _controller;
  Timer? _timer;
  int _elapsedSeconds = 0;
  OrderModel _order = const OrderModel(
    id: 'ORD-4417',
    restaurantName: 'Fusion Kitchen',
    status: OrderStatus.orderPlaced,
    restaurant: _restaurant,
    destination: _destination,
    riderName: 'Alex',
    etaMinutes: 24,
  );

  @override
  Future<BaseResponse> getOrder(GetOrderRequestParams? requestParams) async {
    return BaseResponse(
      status: true,
      code: 200,
      message: 'OK',
      data: _order.toJson(),
    );
  }

  @override
  Stream<OrderModel> watchOrder(String orderId) {
    _controller?.close();
    _timer?.cancel();
    _elapsedSeconds = 0;

    final controller = StreamController<OrderModel>.broadcast(
      onCancel: () => _timer?.cancel(),
    );
    _controller = controller;

    // Resume asynchronously so callers still get a Stream synchronously.
    unawaited(_resumeAndStart(orderId, controller));

    return controller.stream;
  }

  Future<void> _resumeAndStart(
    String orderId,
    StreamController<OrderModel> controller,
  ) async {
    final hive = HiveService();
    final savedId = await hive.read<String>(HiveKeys.activeOrderId);
    final savedStart = await hive.read<int>(HiveKeys.activeOrderStartedAt);

    final now = DateTime.now().millisecondsSinceEpoch;
    if (savedId == orderId && savedStart != null) {
      _elapsedSeconds = ((now - savedStart) / 1000).floor();
    } else {
      _elapsedSeconds = 0;
      await hive.write(HiveKeys.activeOrderId, orderId);
      await hive.write(HiveKeys.activeOrderStartedAt, now);
    }

    if (controller.isClosed) return;

    _order = _advance();
    controller.add(_order);

    if (_order.status.isTerminal) {
      await clearPersistedOrder();
      return;
    }

    _timer = Timer.periodic(tick, (timer) {
      _elapsedSeconds += tick.inSeconds;
      _order = _advance();
      if (!controller.isClosed) controller.add(_order);
      if (_order.status.isTerminal) {
        timer.cancel();
        unawaited(clearPersistedOrder());
      }
    });
  }

  Future<void> clearPersistedOrder() async {
    final hive = HiveService();
    await hive.delete(HiveKeys.activeOrderId);
    await hive.delete(HiveKeys.activeOrderStartedAt);
  }

  OrderModel _advance() {
    final statusIndex = math.min(
      _elapsedSeconds ~/ secondsPerStatus,
      OrderStatus.values.length - 1,
    );
    final status = OrderStatus.values[statusIndex];

    // The rider only appears on the map once the order is picked up, and
    // covers the route over the two statuses that follow.
    GeoPoint? riderLocation;
    if (status.hasRider) {
      final journeySeconds =
          _elapsedSeconds - (OrderStatus.riderPickedUp.index * secondsPerStatus);
      final journeyLength = secondsPerStatus * 2;
      final t = (journeySeconds / journeyLength).clamp(0.0, 1.0);
      riderLocation = _pointAlongRoute(t);
    }

    final remainingStatuses = OrderStatus.values.length - 1 - statusIndex;
    final etaMinutes = status.isTerminal
        ? 0
        : math.max(1, (remainingStatuses * secondsPerStatus / 60 * 8).round());

    return _order.copyWith(
      status: status,
      riderLocation: riderLocation,
      etaMinutes: etaMinutes,
    );
  }


  GeoPoint _pointAlongRoute(double t) {
    final lat = _restaurant.latitude +
        (_destination.latitude - _restaurant.latitude) * t;
    final lng = _restaurant.longitude +
        (_destination.longitude - _restaurant.longitude) * t;
    final arc = math.sin(t * math.pi) * 0.004;
    return GeoPoint(lat + arc, lng);
  }


  List<GeoPoint> get routePoints =>
      List.generate(24, (i) => _pointAlongRoute(i / 23));

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.close();
    _controller = null;
  }
}
