---
to: lib/features/<%= h.changeCase.snake(name) %>/domain/usecases/get_<%= h.changeCase.snake(name) %>_use_case.dart
---
<% Name = h.changeCase.pascal(name) -%><% snake = h.changeCase.snake(name) -%>
import 'package:food_app/base/base_response.dart';
import 'package:food_app/base/base_use_case.dart';
import 'package:food_app/features/<%= snake %>/domain/entities/params/get_<%= snake %>_request_params.dart';
import 'package:food_app/features/<%= snake %>/domain/repository/<%= snake %>_repository.dart';

class Get<%= Name %>UseCase extends BaseUseCase<<%= Name %>Repository,
    Get<%= Name %>RequestParams, BaseResponse> {
  @override
  Future<BaseResponse> call({Get<%= Name %>RequestParams? requestParams}) =>
      repository.get<%= Name %>(requestParams);
}
