import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_textstyle.dart';
import '../../../domain/model/user_data_model.dart';

class FactWidget extends StatefulWidget {
  final UserFectMetaModel factData;
  final Function() onUpdate;
  final int index;
  const FactWidget({
    required this.factData,
    required this.onUpdate,
    required this.index,
    super.key,
  });

  @override
  State<FactWidget> createState() => _FactWidgetState();
}

class _FactWidgetState extends State<FactWidget>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  DateTime? time;
  bool _isTimerStartTed = false;

  AnimationController? animationController;
  Animation<double>? animation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    animation = Tween<double>(begin: 0.0, end: 1).animate(
        CurvedAnimation(parent: animationController!, curve: Curves.easeIn));
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    animationController = null;
    animation = null;
    super.dispose();
  }

  void startTime() async {
    _isTimerStartTed = true;
    await Future.delayed(const Duration(milliseconds: 200));
    if (_isTimerStartTed) {
      animateController();
      time ??= DateTime.now();
      widget.factData.appearanceTime ??= time!.toIso8601String();

      widget.factData.isSeeing = true;
    }
  }

  void animateController() {
    if (!(animationController?.isAnimating ?? true)) {
      animationController!.forward();
    }
  }

  void stopTime() {
    _isTimerStartTed = false;
    if (time != null) {
      final currentTime = DateTime.now();
      widget.factData.duration = currentTime.difference(time!).inSeconds;
      time = null;
      widget.factData.isSeeing = false;

      widget.onUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return VisibilityDetector(
      key: ValueKey(widget.factData.id),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0) {
          startTime();
        } else if (info.visibleFraction == 0.0) {
          stopTime();
        }
      },
      child: FadeTransition(
        opacity: animation!,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: colorList[widget.index % 5],
          ),
          child: Text(
            widget.factData.fact,
            textAlign: TextAlign.center,
            style: AppTextStyles.kText15Regular,
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
