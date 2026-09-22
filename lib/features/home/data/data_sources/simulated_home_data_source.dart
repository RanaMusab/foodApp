import 'package:food_app/base/base_response.dart';
import 'package:food_app/features/home/data/data_sources/home_data_sources.dart';
import 'package:food_app/features/home/domain/entities/params/get_dishes_request_params.dart';


class SimulatedHomeDataSource extends HomeDataSources {
  static const List<Map<String, dynamic>> _menu = [
    {
      'id': 1,
      'name': 'Margherita Pizza',
      'description': 'San Marzano tomato, fior di latte, basil',
      'price': 12.50,
    },
    {
      'id': 2,
      'name': 'Chicken Katsu Curry',
      'description': 'Panko chicken, Japanese curry, steamed rice',
      'price': 14.00,
    },
    {
      'id': 3,
      'name': 'Beef Smash Burger',
      'description': 'Double patty, aged cheddar, house pickles',
      'price': 11.75,
    },
    {
      'id': 4,
      'name': 'Falafel Mezze Bowl',
      'description': 'Hummus, tabbouleh, pickled turnip, tahini',
      'price': 10.25,
    },
    {
      'id': 5,
      'name': 'Pad Thai',
      'description': 'Rice noodles, tamarind, peanuts, lime',
      'price': 12.00,
    },
    {
      'id': 6,
      'name': 'Tiramisu',
      'description': 'Mascarpone, espresso, cocoa',
      'price': 6.50,
    },
  ];

  @override
  Future<BaseResponse> getDishes(GetDishesRequestParams? requestParams) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    final search = requestParams?.search?.trim().toLowerCase();
    final results = (search == null || search.isEmpty)
        ? _menu
        : _menu
              .where(
                (dish) =>
                    (dish['name'] as String).toLowerCase().contains(search),
              )
              .toList();

    return BaseResponse(status: true, code: 200, message: 'OK', data: results);
  }
}
