import 'package:flutter/material.dart';

import 'resources.dart';

class ContainerDecoration {
  BoxDecoration customBoxDecoration = BoxDecoration(
    color: R.colors.white,
    borderRadius: const BorderRadius.all(
      Radius.circular(12),
    ),
    boxShadow: [
      BoxShadow(
        offset: const Offset(0, 0),
        color: R.colors.black.withValues(alpha: .16),
        spreadRadius: 0,
        blurRadius: 6,
      ),
    ],
  );
}
