import 'dart:async';

import '../../model/user_data_model.dart';

abstract class IUSerDataRepository {
  FutureOr<void> addFact(UserDataModel value);
  FutureOr<List<UserDataModel>> getAllFact();
  FutureOr<void> deleteDb();
  FutureOr<void> updatePage(int value);
  FutureOr<int> getPage();
  Future<void> initialize();
}
