import 'dart:async';

import '../../model/user_data_model.dart';

abstract class IUserLocalDataRepository {
  FutureOr<void> addFact(UserFectMetaModel value);
  FutureOr<List<UserFectMetaModel>> getAllFact();
  FutureOr<void> deleteDb();
  FutureOr<void> deleteValues(List<UserFectMetaModel> list);
  FutureOr<void> updatePage(int value);
  FutureOr<int> getPage();
  Future<void> initialize();
}
