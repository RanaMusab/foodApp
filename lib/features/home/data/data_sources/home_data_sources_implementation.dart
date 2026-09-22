import 'package:food_app/base/base_response.dart';
import 'package:food_app/configs/resources/const/api_const.dart';
import 'package:food_app/features/home/data/data_sources/home_data_sources.dart';
import 'package:food_app/features/home/domain/entities/params/get_dishes_request_params.dart';
import 'package:food_app/services/api_service.dart';

class HomeDataSourcesImplementation extends HomeDataSources {
  @override
  Future<BaseResponse> getDishes(GetDishesRequestParams? requestParams) {
    return ApiService().get(
      ApiConfig.dishes,
      query: requestParams?.toJson(),
      cancelPreviousRequests: requestParams?.cancelPreviousRequests,
    );
  }
}
