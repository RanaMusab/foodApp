import 'package:food_app/base/base_provider.dart';
import 'package:food_app/configs/resources/sizing.dart';
import 'package:food_app/features/home/data/models/home_models.dart';
import 'package:food_app/features/home/domain/entities/home_entities.dart';
import 'package:food_app/features/home/domain/entities/params/get_dishes_request_params.dart';
import 'package:food_app/features/home/domain/usecases/get_dishes_use_case.dart';
import 'package:provider/provider.dart';

class HomeProvider extends BaseProvider {
  final GetDishesUseCase _getDishesUseCase = appContext().read();

  List<DishEntity> dishes = [];
  String? errorMessage;

  Future<void> getDishes({String? search}) async {
    await fetchData<dynamic>(
      remoteMethod: () =>
          _getDishesUseCase.call(
            requestParams: GetDishesRequestParams(
              search: search,
              cancelPreviousRequests: true,
            ),
          ),
      onSuccess: (data) {
        errorMessage = null;
        dishes = (data as List? ?? [])
            .map((e) => Dish.fromJson(e as Map<String, dynamic>))
            .toList();
        notifyListeners();
      },
      onError: (message, code) {
        errorMessage = message;
        notifyListeners();
      },
    );
  }
}
