---
to: lib/features/<%= h.changeCase.snake(name) %>/data/repository/<%= h.changeCase.snake(name) %>_data_repository.dart
---
<% Name = h.changeCase.pascal(name) -%><% snake = h.changeCase.snake(name) -%>
import 'package:food_app/base/base_data_repository.dart';
import 'package:food_app/base/base_response.dart';
import 'package:food_app/features/<%= snake %>/data/data_sources/<%= snake %>_data_sources.dart';
import 'package:food_app/features/<%= snake %>/domain/entities/params/get_<%= snake %>_request_params.dart';
import 'package:food_app/features/<%= snake %>/domain/repository/<%= snake %>_repository.dart';

class <%= Name %>DataRepository extends BaseDataRepository<<%= Name %>DataSources>
    implements <%= Name %>Repository {
  @override
  Future<BaseResponse> get<%= Name %>(Get<%= Name %>RequestParams? requestParams) =>
      dataSource.get<%= Name %>(requestParams);
}
