import 'package:food_app/features/home/data/data_sources/home_data_sources.dart';
import 'package:food_app/features/home/data/data_sources/simulated_home_data_source.dart';
import 'package:food_app/features/home/data/repository/home_data_repository.dart';
import 'package:food_app/features/home/domain/repository/home_repository.dart';
import 'package:food_app/features/home/domain/usecases/get_dishes_use_case.dart';
import 'package:food_app/features/home/presentation/provider/home_provider.dart';
import 'package:provider/provider.dart';

final List<dynamic> homeModule = [
  Provider<HomeDataSources>(create: (context) => SimulatedHomeDataSource()),
  Provider<HomeRepository>(create: (context) => HomeDataRepository()),
  Provider<GetDishesUseCase>(create: (context) => GetDishesUseCase()),
  ChangeNotifierProvider<HomeProvider>(create: (context) => HomeProvider()),
];
