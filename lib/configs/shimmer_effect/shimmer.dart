import 'package:flutter/material.dart';
import 'package:food_app/configs/shimmer_effect/gradient_const.dart';
import 'package:food_app/configs/shimmer_effect/shimmer_loading.dart';

class Shimmer extends StatefulWidget {
  static ShimmerState? of(BuildContext context) {
    return context.findAncestorStateOfType<ShimmerState>();
  }

  const Shimmer({super.key, required this.child, this.isLoading = true});

  final LinearGradient linearGradient = GradientConstants.linearGradient;
  final Widget child;
  final bool isLoading;

  @override
  ShimmerState createState() => ShimmerState();
}

class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController.unbounded(vsync: this)..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  // code-excerpt-closing-bracket

  LinearGradient get gradient => LinearGradient(
    colors: widget.linearGradient.colors,
    stops: widget.linearGradient.stops,
    begin: widget.linearGradient.begin,
    end: widget.linearGradient.end,
    transform: _SlidingGradientTransform(slidePercent: _shimmerController.value),
  );

  bool get isSized {
    if (context.findRenderObject() == null) {
      return false;
    }
    return (context.findRenderObject() as RenderBox).hasSize;
  }

  Size get size {
    if (context.findRenderObject() == null) {
      return const Size(0.0, 0.0);
    }
    return (context.findRenderObject() as RenderBox).size;
  }

  Offset getDescendantOffset({required RenderBox descendant, Offset offset = Offset.zero}) {
    final shimmerBox = context.findRenderObject() as RenderBox;
    return descendant.localToGlobal(offset, ancestor: shimmerBox);
  }

  Listenable get shimmerChanges => _shimmerController;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(isLoading: widget.isLoading, child: widget.child);
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
