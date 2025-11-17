// Performance optimization utilities for MyWallet app
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_pocket_wallet/theme/app_theme.dart';
import 'package:flutter/rendering.dart';

class PerformanceConfig {
  // Enable performance overlay (for debugging)
  static void enablePerformanceOverlay() {
    debugPaintSizeEnabled = false; // Disable debug paint for production
  }

  // Optimize scrolling performance
  static const ScrollPhysics optimizedScrollPhysics = BouncingScrollPhysics(
    parent: AlwaysScrollableScrollPhysics(),
  );

  // Prevent unnecessary rebuilds with RepaintBoundary
  static Widget wrapWithRepaintBoundary(Widget child) {
    return RepaintBoundary(child: child);
  }

  // Optimize image loading with proper caching
  static Widget optimizedImage(String assetPath, {double? width, double? height}) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: BoxFit.cover,
      cacheWidth: width?.toInt(),
      cacheHeight: height?.toInt(),
    );
  }

  // Theme data optimized for performance
  static ThemeData get optimizedTheme => AppTheme.dark.copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  // Debounce function to prevent rapid successive calls
  static Timer? _debounceTimer;
  static void debounce(VoidCallback action, Duration delay) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, action);
  }
}

// Custom performance-optimized widgets

// Optimized Container that only rebuilds when necessary
class OptimizedContainer extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxDecoration? decoration;
  final double? width;
  final double? height;

  const OptimizedContainer({
    super.key,
    required this.child,
    this.color,
    this.padding,
    this.margin,
    this.decoration,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: decoration ?? (color != null ? BoxDecoration(color: color) : null),
      child: child,
    );
  }
}

// Performance-optimized ListView
class OptimizedListView extends StatelessWidget {
  final List<Widget> children;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const OptimizedListView({
    super.key,
    required this.children,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: physics ?? PerformanceConfig.optimizedScrollPhysics,
      shrinkWrap: shrinkWrap,
      children: children,
    );
  }
}