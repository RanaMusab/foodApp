import 'dart:async';

import 'package:food_app/base/base_provider.dart';
import 'package:food_app/configs/resources/sizing.dart';
import 'package:food_app/features/order_tracking/data/data_sources/order_tracking_data_sources.dart';
import 'package:food_app/features/order_tracking/data/data_sources/simulated_order_data_source.dart';
import 'package:food_app/features/order_tracking/data/models/order_models.dart';
import 'package:food_app/features/order_tracking/domain/entities/order_entities.dart';
import 'package:food_app/features/order_tracking/domain/entities/order_status.dart';
import 'package:food_app/features/order_tracking/domain/usecases/watch_order_use_case.dart';
import 'package:food_app/services/live_activity_service.dart';
import 'package:provider/provider.dart';

class OrderTrackingProvider extends BaseProvider {
  final WatchOrderUseCase _watchOrderUseCase = appContext().read();
  final OrderTrackingDataSources _dataSource = appContext().read();
  final LiveActivityService _liveActivity = LiveActivityService();

  StreamSubscription<OrderModel>? _subscription;

  OrderModel? order;
  bool liveActivityEnabled = false;

  OrderStatus get status => order?.status ?? OrderStatus.orderPlaced;

  List<GeoPoint> get routePoints {
    final source = _dataSource;
    return source is SimulatedOrderDataSource ? source.routePoints : const [];
  }

  Future<void> startTracking(String orderId) async {
    liveActivityEnabled = await _liveActivity.areActivitiesEnabled();
    notifyListeners();

    await _subscription?.cancel();
    _subscription = _watchOrderUseCase.call(orderId).listen(
      _onOrderUpdate,
      onError: (Object error) => debugState(error),
    );
  }

  void debugState(Object error) {
    // Stream errors are non-fatal here: the last known status stays on screen.
    notifyListeners();
  }

  Future<void> _onOrderUpdate(OrderModel update) async {
    final previousStatus = order?.status;
    final isFirst = order == null;
    order = update;
    notifyListeners();

    if (isFirst) {
      await _liveActivity.start(update);
    } else if (previousStatus != update.status) {
      await _liveActivity.update(update);
    }

    if (update.status.isTerminal) {
      await _subscription?.cancel();
      _subscription = null;
    }
  }

  Future<void> stopTracking({bool endLiveActivity = true}) async {
    await _subscription?.cancel();
    _subscription = null;
    if (endLiveActivity) {
      await _liveActivity.end(immediate: true);
      final source = _dataSource;
      if (source is SimulatedOrderDataSource) {
        await source.clearPersistedOrder();
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _dataSource.dispose();
    super.dispose();
  }
}
