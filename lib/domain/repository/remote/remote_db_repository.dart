import 'dart:async';

import '../../model/user_data_model.dart';

abstract class IRemoteUserDataRepository {
  FutureOr<void> updateData(List<UserDataModel> value);

  Future<void> initialize();
}
