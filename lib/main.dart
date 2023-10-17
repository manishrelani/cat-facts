import 'package:cat_facts/data/remote/appwrite/appwrite_service.dart';
import 'package:cat_facts/util/locator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/local/hive/hive_service.dart';
import 'data/local/hive/hive_user_data_repository.dart';
import 'data/remote/facts_repository.dart';
import 'domain/model/database/hive_fact_model.dart';
import 'presentation/cat_facts/bloc/cat_facts_bloc.dart';
import 'presentation/cat_facts/view/facts_screen.dart';
import 'util/global_keys.dart';
import 'util/hive_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveHelper.init();
  HiveHelper.registerAllAdapter();
  initLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: globalScaffoldKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => CatFactsBloc(
          factsRepository: FactsRepository(locator<Dio>()),
          localUserDataRepository: HiveUserDataRepository(
            userFactDataService: locator<HiveService<HiveUserFactModel>>(),
            userDataService:
                locator<HiveService>(instanceName: HiveHelper.userDataBoxName),
          ),
          remoteUserDataRepository: AppWriteRemoteService(),
        )..add(InitiateEvent()),
        child: const FactsListScreen(),
      ),
    );
  }
}
