import 'package:food_app/base/base_data_repository.dart';
import 'package:food_app/base/base_response.dart';
import 'package:food_app/features/home/data/data_sources/home_data_sources.dart';
import 'package:food_app/features/home/domain/entities/params/get_dishes_request_params.dart';
import 'package:food_app/features/home/domain/repository/home_repository.dart';

class HomeDataRepository extends BaseDataRepository<HomeDataSources>
    implements HomeRepository {
  @override
  Future<BaseResponse> getDishes(GetDishesRequestParams? requestParams) =>
      dataSource.getDishes(requestParams);
}
