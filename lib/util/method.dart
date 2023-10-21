import 'package:flutter/material.dart';

import '../core/constant/app_color.dart';
import '../core/constant/app_textstyle.dart';

class Methods {
  const Methods._();

  static showWarningSnackBar(
      {required BuildContext context, required String message}) {
    final scafoldMessaenger = ScaffoldMessenger.of(context);
    scafoldMessaenger.removeCurrentSnackBar();
    scafoldMessaenger.showSnackBar(
      SnackBar(
        backgroundColor: Colors.orange.shade300,
        duration: const Duration(days: 1),
        dismissDirection: DismissDirection.none,
        content: Text(
          message,
          style: AppTextStyles.kText16Regular.copyWith(color: AppColors.white),
        ),
      ),
    );
  }

  static removeSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }
}
