import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/home/di/home_module.dart';
import 'features/order_tracking/di/order_tracking_module.dart';
import 'features/splash/di/splash_module.dart';

class Injector extends StatelessWidget {
  final Widget myApp;

  const Injector({super.key, required this.myApp});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...splashModule,
        ...homeModule,
        ...orderTrackingModule,
      ],
      child: myApp,
    );
  }
}
