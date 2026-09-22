import 'package:food_app/base/base_response.dart';
import 'package:food_app/features/order_tracking/data/models/order_models.dart';
import 'package:food_app/features/order_tracking/domain/entities/params/get_order_request_params.dart';

abstract class OrderTrackingRepository {
  Future<BaseResponse> getOrder(GetOrderRequestParams? requestParams);

  Stream<OrderModel> watchOrder(String orderId);
}
