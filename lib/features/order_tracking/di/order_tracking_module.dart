import 'package:food_app/features/order_tracking/data/data_sources/order_tracking_data_sources.dart';
import 'package:food_app/features/order_tracking/data/data_sources/simulated_order_data_source.dart';
import 'package:food_app/features/order_tracking/data/repository/order_tracking_data_repository.dart';
import 'package:food_app/features/order_tracking/domain/repository/order_tracking_repository.dart';
import 'package:food_app/features/order_tracking/domain/usecases/get_order_use_case.dart';
import 'package:food_app/features/order_tracking/domain/usecases/watch_order_use_case.dart';
import 'package:food_app/features/order_tracking/presentation/provider/order_tracking_provider.dart';
import 'package:provider/provider.dart';

final List<dynamic> orderTrackingModule = [
  Provider<OrderTrackingDataSources>(
    create: (context) => SimulatedOrderDataSource(),
  ),
  Provider<OrderTrackingRepository>(
    create: (context) => OrderTrackingDataRepository(),
  ),
  Provider<GetOrderUseCase>(create: (context) => GetOrderUseCase()),
  Provider<WatchOrderUseCase>(create: (context) => WatchOrderUseCase()),
  ChangeNotifierProvider<OrderTrackingProvider>(
    create: (context) => OrderTrackingProvider(),
  ),
];
