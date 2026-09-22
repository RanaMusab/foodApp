---
to: lib/features/<%= h.changeCase.snake(name) %>/domain/entities/params/get_<%= h.changeCase.snake(name) %>_request_params.dart
---
<% Name = h.changeCase.pascal(name) -%>
import 'package:food_app/base/base_request_param.dart';

class Get<%= Name %>RequestParams extends BaseRequestParam {
  Get<%= Name %>RequestParams({super.cancelPreviousRequests});

  Map<String, dynamic> toJson() => {};
}
