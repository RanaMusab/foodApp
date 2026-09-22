import 'package:provider/provider.dart';
import 'package:food_app/configs/resources/sizing.dart' show appContext;

/*
 * This is a template class, that takes the following type templates while extending:
 * REPO: this is the type of repository.
 * REQUEST: this is the type of request parameter to send in call method.
 * RETURN : this is the type of return value you are expecting from response/method.
 */

abstract class BaseUseCase<REPO, REQUEST, RETURN> {
  BaseUseCase() {
    repository = appContext().read();
  }

  late final REPO repository;

  Future<RETURN> call({REQUEST? requestParams});
}
