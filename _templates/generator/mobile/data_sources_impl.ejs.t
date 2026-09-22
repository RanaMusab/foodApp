---
to: lib/features/<%= h.changeCase.snake(name) %>/data/data_sources/<%= h.changeCase.snake(name) %>_data_sources_implementation.dart
---
<% Name = h.changeCase.pascal(name) -%><% snake = h.changeCase.snake(name) -%>
import 'package:food_app/base/base_response.dart';
import 'package:food_app/configs/resources/const/api_const.dart';
import 'package:food_app/features/<%= snake %>/data/data_sources/<%= snake %>_data_sources.dart';
import 'package:food_app/features/<%= snake %>/domain/entities/params/get_<%= snake %>_request_params.dart';
import 'package:food_app/services/api_service.dart';

class <%= Name %>DataSourcesImplementation extends <%= Name %>DataSources {
  @override
  Future<BaseResponse> get<%= Name %>(Get<%= Name %>RequestParams? requestParams) {
    // TODO: add the endpoint to ApiConfig.
    return ApiService().get(
      ApiConfig.baseUrl,
      query: requestParams?.toJson(),
      cancelPreviousRequests: requestParams?.cancelPreviousRequests,
    );
  }
}
