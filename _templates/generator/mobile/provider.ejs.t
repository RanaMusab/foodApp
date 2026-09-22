---
to: lib/features/<%= h.changeCase.snake(name) %>/presentation/provider/<%= h.changeCase.snake(name) %>_provider.dart
---
<% Name = h.changeCase.pascal(name) -%><% snake = h.changeCase.snake(name) -%>
import 'package:food_app/base/base_provider.dart';
import 'package:food_app/configs/resources/sizing.dart';
import 'package:food_app/features/<%= snake %>/data/models/<%= snake %>_models.dart';
import 'package:food_app/features/<%= snake %>/domain/entities/<%= snake %>_entities.dart';
import 'package:food_app/features/<%= snake %>/domain/entities/params/get_<%= snake %>_request_params.dart';
import 'package:food_app/features/<%= snake %>/domain/usecases/get_<%= snake %>_use_case.dart';
import 'package:provider/provider.dart';

class <%= Name %>Provider extends BaseProvider {
  final Get<%= Name %>UseCase _get<%= Name %>UseCase = appContext().read();

  List<<%= Name %>Entity> items = [];
  String? errorMessage;

  Future<void> get<%= Name %>() async {
    await fetchData<dynamic>(
      remoteMethod: () => _get<%= Name %>UseCase.call(
        requestParams: Get<%= Name %>RequestParams(cancelPreviousRequests: true),
      ),
      onSuccess: (data) {
        errorMessage = null;
        items = (data as List? ?? [])
            .map((e) => <%= Name %>Model.fromJson(e as Map<String, dynamic>))
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
