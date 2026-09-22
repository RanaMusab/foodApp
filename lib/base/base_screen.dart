import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:food_app/base/base_provider.dart';

abstract class BaseScreen<C extends StatefulWidget, V extends BaseProvider?>
    extends State<C> {
  V? viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = context.read<V>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void gotoScreen(String routeName, {bool? clearStack, dynamic arguments}) {
    if (clearStack == true) {
      context.go(routeName, extra: arguments); // Replaces the entire stack
    } else {
      context.push(routeName, extra: arguments); // Pushes onto the stack
    }
  }

  void goBack() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (context.canPop()) {
      context.pop();
    }
  }
}
