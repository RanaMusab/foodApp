import 'dart:io';

import 'package:flutter/material.dart';

import 'injector.dart';
import 'main.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  static void restart(BuildContext context) {
    context.findAncestorStateOfType<_AppWrapperState>()?._restartApp();
  }

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  Key _injectorKey = UniqueKey();

  void _restartApp() {
    setState(() => _injectorKey = UniqueKey());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: Platform.isIOS ? false : true,
      child: Injector(key: _injectorKey, myApp: const MyApp()),
    );
  }
}
