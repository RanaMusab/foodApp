import 'package:food_app/base/base_data_repository.dart';
import 'package:food_app/base/base_response.dart';
import 'package:food_app/features/order_tracking/data/data_sources/order_tracking_data_sources.dart';
import 'package:food_app/features/order_tracking/data/models/order_models.dart';
import 'package:food_app/features/order_tracking/domain/entities/params/get_order_request_params.dart';
import 'package:food_app/features/order_tracking/domain/repository/order_tracking_repository.dart';

class OrderTrackingDataRepository
    extends BaseDataRepository<OrderTrackingDataSources>
    implements OrderTrackingRepository {
  @override
  Future<BaseResponse> getOrder(GetOrderRequestParams? requestParams) =>
      dataSource.getOrder(requestParams);

  @override
  Stream<OrderModel> watchOrder(String orderId) =>
      dataSource.watchOrder(orderId);
}
