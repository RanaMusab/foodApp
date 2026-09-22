import 'package:food_app/base/base_response.dart';
import 'package:food_app/base/base_use_case.dart';
import 'package:food_app/features/home/domain/entities/params/get_dishes_request_params.dart';
import 'package:food_app/features/home/domain/repository/home_repository.dart';

class GetDishesUseCase
    extends BaseUseCase<HomeRepository, GetDishesRequestParams, BaseResponse> {
  @override
  Future<BaseResponse> call({GetDishesRequestParams? requestParams}) =>
      repository.getDishes(requestParams);
}
