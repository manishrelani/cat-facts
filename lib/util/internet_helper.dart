import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../core/constant/app_color.dart';
import '../core/constant/app_textstyle.dart';
import 'global_keys.dart';

class InternetHelper {
  const InternetHelper._();

  static StreamSubscription<InternetConnectionStatus>? _subscription;
  static InternetConnectionChecker get helper => InternetConnectionChecker();

  static Stream<InternetConnectionStatus> get stream =>
      InternetConnectionChecker().onStatusChange;

  static void listen() {
    _subscription = InternetConnectionChecker().onStatusChange.listen(
      (event) {
        if (event == InternetConnectionStatus.disconnected) {
          if (globalScaffoldKey.currentState != null) {
            globalScaffoldKey.currentState!.removeCurrentSnackBar();
            globalScaffoldKey.currentState!.showSnackBar(
              SnackBar(
                backgroundColor: AppColors.kDangerColor,
                duration: const Duration(days: 1),
                content: SafeArea(
                  bottom: true,
                  child: Text(
                    "Not able to connect with internet, Please check your internt connection",
                    style: AppTextStyles.kText16Regular
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            );
          }
        } else {
          if (globalScaffoldKey.currentState != null) {
            globalScaffoldKey.currentState!.hideCurrentSnackBar();
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
