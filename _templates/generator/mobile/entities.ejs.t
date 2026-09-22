---
to: lib/features/<%= h.changeCase.snake(name) %>/domain/entities/<%= h.changeCase.snake(name) %>_entities.dart
---
<% Name = h.changeCase.pascal(name) -%>
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class <%= Name %>Entity extends Equatable {
  const <%= Name %>Entity({this.id});

  final int? id;

  @override
  List<Object?> get props => [id];
}
