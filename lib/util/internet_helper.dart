import 'dart:async';

import 'package:cat_facts/core/app_color.dart';
import 'package:cat_facts/core/config/app_textstyle.dart';
import 'package:cat_facts/util/global_keys.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetHelper {
  const InternetHelper._();

  static StreamSubscription<InternetConnectionStatus>? _subscription;

  static Stream<InternetConnectionStatus> get stream =>
      InternetConnectionChecker().onStatusChange;

  static bool _isShowing = false;

  static void init() {
    _subscription = InternetConnectionChecker().onStatusChange.listen(
      (event) {
        if (event == InternetConnectionStatus.disconnected) {
          if (globalScaffoldKey.currentState != null) {
            _isShowing = true;
            globalScaffoldKey.currentState!.showSnackBar(
              SnackBar(
                backgroundColor: AppColors.kDangerColor,
                duration: const Duration(days: 1),
                content: SafeArea(
                  bottom: true,
                  child: Text(
                    "Please check your internet",
                    style: AppTextStyles.kText16Regular
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            );
          }
        } else {
          if (globalScaffoldKey.currentState != null && _isShowing) {
            _isShowing = false;
            globalScaffoldKey.currentState!.removeCurrentSnackBar();
          }
        }
      },
    );
  }

  static void stop() {
    _subscription?.cancel();
    _subscription = null;
  }
}
