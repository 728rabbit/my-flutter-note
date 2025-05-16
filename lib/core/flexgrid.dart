import 'package:flutter/material.dart';

class FlexGrid extends StatelessWidget {
  final int maxDisplayCount;
  final int minDisplayCount;
  final List<Widget> items;
  final double breakpoint;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsetsGeometry padding;
  final double childAspectRatio;

  const FlexGrid({
    super.key,
    required this.maxDisplayCount,
    required this.items,
    this.minDisplayCount = 1,
    this.breakpoint = 680,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 16,
    this.padding = const EdgeInsets.all(0),
    this.childAspectRatio = 1,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth < breakpoint ? minDisplayCount : maxDisplayCount;

    return GridView.builder(
      padding: padding,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => items[index]
    );
  }
}