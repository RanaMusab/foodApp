---
to: lib/features/<%= h.changeCase.snake(name) %>/presentation/view/<%= h.changeCase.snake(name) %>_view.dart
---
<% Name = h.changeCase.pascal(name) -%><% snake = h.changeCase.snake(name) -%>
import 'package:flutter/material.dart';
import 'package:food_app/base/base_screen.dart';
import 'package:food_app/configs/resources/resources.dart';
import 'package:food_app/features/<%= snake %>/presentation/provider/<%= snake %>_provider.dart';
import 'package:provider/provider.dart';

class <%= Name %>View extends StatefulWidget {
  const <%= Name %>View({super.key});

  /// Register this in AppRoutes.router.
  static const String route = '/<%= Name %>View';

  @override
  State<<%= Name %>View> createState() => _<%= Name %>ViewState();
}

class _<%= Name %>ViewState extends BaseScreen<<%= Name %>View, <%= Name %>Provider> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => viewModel?.get<%= Name %>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('<%= Name %>', style: R.textStyles.font18B),
      ),
      body: Consumer<<%= Name %>Provider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.items.length,
            itemBuilder: (context, index) =>
                ListTile(title: Text('${provider.items[index].id}')),
          );
        },
      ),
    );
  }
}
