import 'package:food_app/base/base_provider.dart';
import 'package:food_app/configs/utils/singleton.dart';
import 'package:food_app/services/hive_service.dart';

class SplashProvider extends BaseProvider {
  Future<bool> restoreSession() async {
    final token = await HiveService().read<String>(HiveKeys.token);
    if (token != null && token.isNotEmpty) {
      Singleton.token = token;
      return true;
    }
    return false;
  }
}
