---
to: lib/features/<%= h.changeCase.snake(name) %>/data/data_sources/<%= h.changeCase.snake(name) %>_data_sources.dart
---
<% Name = h.changeCase.pascal(name) -%><% snake = h.changeCase.snake(name) -%>
import 'package:food_app/base/base_response.dart';
import 'package:food_app/features/<%= snake %>/domain/entities/params/get_<%= snake %>_request_params.dart';

abstract class <%= Name %>DataSources {
  Future<BaseResponse> get<%= Name %>(Get<%= Name %>RequestParams? requestParams);
}
