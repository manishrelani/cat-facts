import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constant/app_textstyle.dart';
import '../../../domain/model/user_data_model.dart';
import '../../../util/method.dart';
import '../bloc/cat_facts_bloc.dart';
import '../widget/fact_widget.dart';
import '../widget/loading_widget.dart';
import '../widget/new_update_widget.dart';
import '../widget/orientation_background.dart';

class FactsListScreen extends StatelessWidget {
  const FactsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Cat Facts",
          style: AppTextStyles.kText16Medium,
        ),
      ),
      body: Stack(
        children: [
          MediaQuery.orientationOf(context) == Orientation.portrait
              ? const PortraitBackground()
              : const LandscapeBackground(),
          BlocConsumer<CatFactsBloc, CatFactsState>(
            listenWhen: (previous, current) => current is CatFactsContext,
            listener: (BuildContext context, CatFactsState state) {
              if (state is ShowWarning) {
                Methods.showWarningSnackBar(
                    context: context, message: state.message);
              } else if (state is RemoveWarning) {
                Methods.removeSnackBar(context);
              }
            },
            buildWhen: (previous, current) =>
                current is CatFactsLoading || current is CatFactsUpdated,
            builder: (BuildContext context, CatFactsState state) {
              if (state is CatFactsUpdated) {
                return CatFactsListView(state.facts, state.hasNewUpdate);
              }
              return const LoadingWidget();
            },
          ),
        ],
      ),
    );
  }
}

class CatFactsListView extends StatefulWidget {
  final List<UserFectMetaModel> factsList;
  final bool hasNewUpdate;
  const CatFactsListView(this.factsList, this.hasNewUpdate, {super.key});

  @override
  State<CatFactsListView> createState() => _CatFactsListViewState();
}

class _CatFactsListViewState extends State<CatFactsListView> {
  final controller = ScrollController();

  late bool hasNewUpdate = widget.hasNewUpdate;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.addListener(_updateScroll);
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_updateScroll);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CatFactsListView oldWidget) {
    if (widget.hasNewUpdate) {
      setState(() {
        hasNewUpdate = true;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void _updateScroll() {
    if (controller.position.pixels == controller.position.minScrollExtent &&
        hasNewUpdate) {
      setState(() {
        hasNewUpdate = false;
      });
    }
    context.read<CatFactsBloc>().add(UserScrollEvent());
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CatFactsBloc>();
    return Stack(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            controller: controller,
            addAutomaticKeepAlives: true,
            itemExtent: constraints.maxHeight * 0.33,
            itemCount: widget.factsList.length,
            itemBuilder: (context, index) {
              final fact = widget.factsList[index];

              return FactWidget(
                key: ValueKey(fact.id),
                factData: fact,
                index: index,
                onUpdate: () {
                  bloc.add(
                    UpdateUserMetaDataEvent(fact.copyWith()),
                  );
                },
              );
            },
          );
        }),
        if (hasNewUpdate)
          NewUpdateWidget(
            onTap: () => controller.animateTo(0,
                curve: Curves.linear,
                duration: const Duration(milliseconds: 400)),
          )
      ],
    );
  }
}
