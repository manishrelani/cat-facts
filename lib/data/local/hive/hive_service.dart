import 'dart:async';

import 'package:hive/hive.dart';

import '../../../domain/repository/local/local_database_repository.dart';

class HiveService<E> implements ILocalDatabseService<E> {
  Box<E>? _box;

  bool get isInitialized => _box?.isOpen ?? false;

  final String boxName;

  HiveService(this.boxName);

  @override
  Future<void> initDb() async {
    _box = await Hive.openBox<E>(boxName);
  }

  @override
  Box<E> get getDbInstance => Hive.box<E>(boxName);

  @override
  Future<void> close() async {
    await Hive.box<E>(boxName).close();
  }
}
