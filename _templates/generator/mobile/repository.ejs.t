---
to: lib/features/<%= h.changeCase.snake(name) %>/domain/repository/<%= h.changeCase.snake(name) %>_repository.dart
---
<% Name = h.changeCase.pascal(name) -%><% snake = h.changeCase.snake(name) -%>
import 'package:food_app/base/base_response.dart';
import 'package:food_app/features/<%= snake %>/domain/entities/params/get_<%= snake %>_request_params.dart';

abstract class <%= Name %>Repository {
  Future<BaseResponse> get<%= Name %>(Get<%= Name %>RequestParams? requestParams);
}
