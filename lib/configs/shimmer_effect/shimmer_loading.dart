import 'package:flutter/material.dart';
import 'package:food_app/configs/shimmer_effect/shimmer.dart';

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({super.key, required this.isLoading, required this.child});

  final bool isLoading;
  final Widget child;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  Listenable? _shimmerChanges;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_shimmerChanges != null) {
      _shimmerChanges!.removeListener(_onShimmerChange);
    }
    _shimmerChanges = Shimmer.of(context)?.shimmerChanges;
    if (_shimmerChanges != null) {
      _shimmerChanges!.addListener(_onShimmerChange);
    }
  }

  @override
  void dispose() {
    _shimmerChanges?.removeListener(_onShimmerChange);
    super.dispose();
  }

  void _onShimmerChange() {
    if (widget.isLoading) {
      setState(() {
        // update the shimmer painting.
      });
    }
  }

  // code-excerpt-closing-bracket

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    // Collect ancestor shimmer info.
    final shimmer = Shimmer.of(context)!;
    if (!shimmer.isSized) {
      // The ancestor Shimmer widget has not laid
      // itself out yet. Return an empty box.
      return const SizedBox();
    }
    final shimmerSize = shimmer.size;
    final gradient = shimmer.gradient;
    Offset? offsetWithinShimmer = context.findRenderObject() != null ? shimmer.getDescendantOffset(descendant: context.findRenderObject() as RenderBox) : null;

    return offsetWithinShimmer != null
        ? ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return gradient.createShader(Rect.fromLTWH(-offsetWithinShimmer.dx, -offsetWithinShimmer.dy, shimmerSize.width, shimmerSize.height));
          },
          child: widget.child,
        )
        : const SizedBox();
  }
}
