import 'dart:async';

import '../../../domain/model/database/hive_fact_model.dart';
import '../../../domain/model/user_data_model.dart';
import '../../../domain/repository/local/user_data_repository.dart';
import '../../../util/hive_helper.dart';
import 'hive_service.dart';

class HiveUserMetaRepository extends IUserLocalDataRepository {
  final HiveService<HiveUserFactModel> _userFactDataService;
  final HiveService _userDataService;
  HiveUserMetaRepository(
      {required HiveService<HiveUserFactModel> userFactDataService,
      required HiveService userDataService})
      : _userDataService = userDataService,
        _userFactDataService = userFactDataService;

  @override
  Future<void> addFact(UserFectMetaModel value) async {
    final hiveObject = HiveUserFactModel(
      fact: value.fact,
      arrivingtime: value.appearanceTime ?? "",
      duration: value.duration,
      id: value.id,
    );

    await _userFactDataService.getDbInstance.put(value.id, hiveObject);
  }

  @override
  int getPage() {
    return _userDataService.getDbInstance
        .get(HiveHelper.pageKey, defaultValue: 1);
  }

  @override
  FutureOr<void> updatePage(int value) {
    return _userDataService.getDbInstance.put(HiveHelper.pageKey, value);
  }

  @override
  Future<void> initialize() async {
    await Future.wait([
      _userFactDataService.initDb(),
      _userDataService.initDb(),
    ]);
  }

  @override
  List<UserFectMetaModel> getAllFact() {
    return _userFactDataService.getDbInstance.values
        .map((e) => UserFectMetaModel(
              id: e.key,
              fact: e.fact,
              appearanceTime: e.arrivingtime,
              duration: e.duration,
            ))
        .toList();
  }

  @override
  FutureOr<void> deleteDb() async {
    await _userFactDataService.getDbInstance.clear();
    await _userDataService.getDbInstance.clear();
  }

  @override
  FutureOr<void> deleteValues(List<UserFectMetaModel> list) async {
    await _userFactDataService.getDbInstance.deleteAll(list.map((e) => e.id));
  }
}
