import 'package:flutter/material.dart';

import '../../../widget/shimmer_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      highlightColor: Colors.grey.shade50,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: List.generate(
            5,
            (index) => Container(
              height: 300,
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
