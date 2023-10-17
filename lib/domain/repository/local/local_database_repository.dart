import 'dart:async';

abstract class ILocalDatabseService<E> {
  Future<void> initDb();
  get getDbInstance;
  FutureOr<void> close();
}
