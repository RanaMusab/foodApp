import 'package:food_app/base/base_request_param.dart';

class GetOrderRequestParams extends BaseRequestParam {
  GetOrderRequestParams({super.cancelPreviousRequests, required this.orderId});

  final String orderId;

  Map<String, dynamic> toJson() => {'order_id': orderId};
}
