---
to: lib/features/<%= h.changeCase.snake(name) %>/di/<%= h.changeCase.snake(name) %>_module.dart
---
<% Name = h.changeCase.pascal(name) -%><% snake = h.changeCase.snake(name) -%>
import 'package:food_app/features/<%= snake %>/data/data_sources/<%= snake %>_data_sources.dart';
import 'package:food_app/features/<%= snake %>/data/data_sources/<%= snake %>_data_sources_implementation.dart';
import 'package:food_app/features/<%= snake %>/data/repository/<%= snake %>_data_repository.dart';
import 'package:food_app/features/<%= snake %>/domain/repository/<%= snake %>_repository.dart';
import 'package:food_app/features/<%= snake %>/domain/usecases/get_<%= snake %>_use_case.dart';
import 'package:food_app/features/<%= snake %>/presentation/provider/<%= snake %>_provider.dart';
import 'package:provider/provider.dart';

/// Remember to spread `<%= h.changeCase.camel(name) %>Module` in lib/injector.dart.
final List<dynamic> <%= h.changeCase.camel(name) %>Module = [
  Provider<<%= Name %>DataSources>(
    create: (context) => <%= Name %>DataSourcesImplementation(),
  ),
  Provider<<%= Name %>Repository>(create: (context) => <%= Name %>DataRepository()),
  Provider<Get<%= Name %>UseCase>(create: (context) => Get<%= Name %>UseCase()),
  ChangeNotifierProvider<<%= Name %>Provider>(
    create: (context) => <%= Name %>Provider(),
  ),
];
