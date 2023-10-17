import 'package:cat_facts/core/config/app_textstyle.dart';
import 'package:cat_facts/core/image_constant.dart';
import 'package:cat_facts/util/methoda.dart';
import 'package:cat_facts/widget/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../domain/model/facts_responce_model.dart';
import '../../../domain/model/user_data_model.dart';
import '../bloc/cat_facts_bloc.dart';

class FactsListScreen extends StatelessWidget {
  const FactsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          "Cat Facts",
          style: AppTextStyles.kText16Medium.copyWith(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Image.asset(
                  AppImage.pawBackgroundPng,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Image.asset(
                  AppImage.pawBackgroundPng,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          BlocConsumer<CatFactsBloc, CatFactsState>(
            listenWhen: (previous, current) => current is CatFactsContext,
            listener: (BuildContext context, CatFactsState state) {
              if (state is ShowWarning) {
                Methods.showWarningSnackBar(
                    context: context, message: state.message);
              } else if (state is RemoeWarning) {
                Methods.removeSnackBar(context);
              }
            },
            buildWhen: (previous, current) =>
                current is CatFactsLoading || current is CatFactsLoaded,
            builder: (BuildContext context, CatFactsState state) {
              if (state is CatFactsLoaded) {
                return CatFactsListView(state.facts);
              }
              return const _LoadingWidget();
            },
          ),
        ],
      ),
    );
  }
}

class CatFactsListView extends StatelessWidget {
  final List<FactsModel> factsList;
  const CatFactsListView(this.factsList, {super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CatFactsBloc>();
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        bloc.add(UserScrollEvent());
        return true;
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
        children: List.generate(
          factsList.length,
          (index) => AnimationConfiguration.staggeredList(
            key: ValueKey(factsList[index]),
            position: index,
            duration: const Duration(milliseconds: 400),
            child: SlideAnimation(
              horizontalOffset: 400.0,
              curve: Curves.easeIn,
              child: FactWidget(
                factData: factsList[index],
                onDispose: (appearanceTime, duration) {
                  bloc.add(
                    UpdateUserDataOnFactsEvent(
                      UserDataModel(
                        fact: factsList[index].fact,
                        appearanceTime: appearanceTime,
                        duration: duration,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onDispose(
      BuildContext context, String fact, String appearanceTime, int duration) {}
}

class FactWidget extends StatefulWidget {
  final FactsModel factData;
  final Function(String appearanceTime, int duration) onDispose;
  const FactWidget(
      {required this.factData, required this.onDispose, super.key});

  @override
  State<FactWidget> createState() => _FactWidgetState();
}

class _FactWidgetState extends State<FactWidget> {
  late String appearanceTime;
  final stopWatch = Stopwatch();

  @override
  void initState() {
    appearanceTime = DateTime.now().toIso8601String();
    stopWatch.start();
    super.initState();
  }

  @override
  void deactivate() {
    stopWatch.stop();
    widget.onDispose(appearanceTime, stopWatch.elapsedMilliseconds);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          widget.factData.fact,
          style: AppTextStyles.kText16Regular,
        ),
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

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
              height: 100,
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
