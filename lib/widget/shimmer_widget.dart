import 'package:cat_facts/core/app_color.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final Widget child;
  final Color? highlightColor;

  const CustomShimmer({Key? key, required this.child, this.highlightColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: const Color(0xFFEBEBEB),
        highlightColor: highlightColor ?? AppColors.backgroundColor,
        child: child);
  }
}
