import 'package:food_app/configs/resources/sizing.dart';
import 'package:food_app/features/order_tracking/data/models/order_models.dart';
import 'package:food_app/features/order_tracking/domain/repository/order_tracking_repository.dart';
import 'package:provider/provider.dart';

class WatchOrderUseCase {
  WatchOrderUseCase() {
    repository = appContext().read();
  }

  late final OrderTrackingRepository repository;

  Stream<OrderModel> call(String orderId) => repository.watchOrder(orderId);
}
