import 'package:food_app/base/base_response.dart';
import 'package:food_app/base/base_use_case.dart';
import 'package:food_app/features/order_tracking/domain/entities/params/get_order_request_params.dart';
import 'package:food_app/features/order_tracking/domain/repository/order_tracking_repository.dart';

class GetOrderUseCase extends BaseUseCase<OrderTrackingRepository,
    GetOrderRequestParams, BaseResponse> {
  @override
  Future<BaseResponse> call({GetOrderRequestParams? requestParams}) =>
      repository.getOrder(requestParams);
}
