import 'package:food_app/base/base_response.dart';
import 'package:food_app/features/home/domain/entities/params/get_dishes_request_params.dart';

abstract class HomeDataSources {
  Future<BaseResponse> getDishes(GetDishesRequestParams? requestParams);
}
