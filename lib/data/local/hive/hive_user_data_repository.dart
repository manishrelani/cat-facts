import 'dart:async';

import '../../../domain/model/database/hive_fact_model.dart';
import '../../../domain/model/user_data_model.dart';
import '../../../domain/repository/local/user_data_repository.dart';
import '../../../util/hive_helper.dart';
import 'hive_service.dart';

class HiveUserDataRepository extends IUSerDataRepository {
  final HiveService<HiveUserFactModel> _userFactDataService;
  final HiveService _userDataService;
  HiveUserDataRepository(
      {required HiveService<HiveUserFactModel> userFactDataService,
      required HiveService userDataService})
      : _userDataService = userDataService,
        _userFactDataService = userFactDataService;

  @override
  Future<void> addFact(UserDataModel value) async {
    final hiveObject = HiveUserFactModel(
        fact: value.fact,
        arrivingtime: value.appearanceTime,
        duration: value.duration);

    await _userFactDataService.getDbInstance.add(hiveObject);
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
  List<UserDataModel> getAllFact() {
    return _userFactDataService.getDbInstance.values
        .map((e) => UserDataModel(
            fact: e.fact, appearanceTime: e.arrivingtime, duration: e.duration))
        .toList();
  }

  @override
  FutureOr<void> deleteDb() {
    _userFactDataService.getDbInstance.clear();
  }
}
