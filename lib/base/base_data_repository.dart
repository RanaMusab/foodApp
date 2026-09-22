import 'package:provider/provider.dart';
import 'package:food_app/configs/resources/sizing.dart';

abstract class BaseDataRepository<C> {
  BaseDataRepository() {
    dataSource = appContext().read();
  }

  late final C dataSource;
}
