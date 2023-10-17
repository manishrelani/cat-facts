import 'package:cat_facts/core/api_constant.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../data/local/hive/hive_service.dart';
import '../domain/model/database/hive_fact_model.dart';
import 'hive_helper.dart';

final locator = GetIt.I;

void initLocator() {
  locator.registerLazySingleton<HiveService<HiveUserFactModel>>(
    () => HiveService<HiveUserFactModel>(HiveHelper.userDataFactsBoxName),
    dispose: (e) => e.close(),
  );
  locator.registerLazySingleton<HiveService>(
    () => HiveService(HiveHelper.userDataBoxName),
    instanceName: HiveHelper.userDataBoxName,
    dispose: (e) => e.close(),
  );

  locator.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(baseUrl: APIConst.baseUrl),
    ),
  );
}
