import 'package:flutter/material.dart';

import '../../../core/constant/app_textstyle.dart';

class NewUpdateWidget extends StatelessWidget {
  final Function() onTap;
  const NewUpdateWidget({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: Colors.blue),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                "New Update",
                style:
                    AppTextStyles.kText16Medium.copyWith(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
