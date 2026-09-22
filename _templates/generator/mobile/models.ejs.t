---
to: lib/features/<%= h.changeCase.snake(name) %>/data/models/<%= h.changeCase.snake(name) %>_models.dart
---
<% Name = h.changeCase.pascal(name) -%><% snake = h.changeCase.snake(name) -%>
import 'package:food_app/features/<%= snake %>/domain/entities/<%= snake %>_entities.dart';

class <%= Name %>Model extends <%= Name %>Entity {
  const <%= Name %>Model({super.id});

  factory <%= Name %>Model.fromJson(Map<String, dynamic> json) =>
      <%= Name %>Model(id: json['id'] as int?);

  Map<String, dynamic> toJson() => {'id': id};
}
