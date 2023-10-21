import 'dart:async';

import '../../model/user_data_model.dart';

abstract class IRemoteUserFactsMetaRepository {
  FutureOr<void> updateData(List<UserFectMetaModel> value);

  Future<void> initialize();
}
