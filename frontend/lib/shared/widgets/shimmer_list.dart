import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Caixa shimmer genérica para placeholders de carregamento
class ShimmerBox extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.height,
    this.width,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF2A2A3E) : const Color(0xFFE8E8F0);
    final highlightColor = isDark ? const Color(0xFF3A3A50) : const Color(0xFFF5F5FF);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Lista vertical de shimmer cards
class ShimmerVerticalList extends StatelessWidget {
  final int count;

  const ShimmerVerticalList({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (i) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: const ShimmerBox(height: 80),
        ),
      ),
    );
  }
}

/// Lista horizontal de shimmer cards
class ShimmerHorizontalList extends StatelessWidget {
  final double itemWidth;
  final double height;
  final int count;

  const ShimmerHorizontalList({
    super.key,
    required this.itemWidth,
    required this.height,
    this.count = 6,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: count,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) => ShimmerBox(height: height, width: itemWidth),
      ),
    );
  }
}
