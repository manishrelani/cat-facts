import 'package:flutter/material.dart';

import '../../../core/constant/image_constant.dart';

class PortraitBackground extends StatelessWidget {
  const PortraitBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Image.asset(
            AppImage.pawBackgroundPng,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: SizedBox(
            width: double.maxFinite,
            child: Image.asset(
              AppImage.pawBackgroundPng,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

class LandscapeBackground extends StatelessWidget {
  const LandscapeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Column(
            children: [child, child],
          ),
        ),
        Flexible(
          child: Column(
            children: [child, child],
          ),
        ),
      ],
    );
  }

  Widget get child => Expanded(
        child: SizedBox(
          width: double.maxFinite,
          child: Image.asset(
            AppImage.pawBackgroundPng,
            fit: BoxFit.fill,
          ),
        ),
      );
}
