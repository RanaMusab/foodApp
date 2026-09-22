import 'package:food_app/features/splash/presentation/provider/splash_provider.dart';
import 'package:provider/provider.dart';

final List<dynamic> splashModule = [
  ChangeNotifierProvider<SplashProvider>(create: (context) => SplashProvider()),
];
