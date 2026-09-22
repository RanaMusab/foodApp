import 'package:food_app/base/base_request_param.dart';

class GetDishesRequestParams extends BaseRequestParam {
  GetDishesRequestParams({
    super.cancelPreviousRequests,
    this.page = 1,
    this.search,
  });

  final int page;
  final String? search;

  Map<String, dynamic> toJson() => {'page': page, 'search': search};
}
