import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/model/database/hive_fact_model.dart';

class HiveHelper {
  const HiveHelper._();

  static Future<void> init() async {
    final value = await getApplicationDocumentsDirectory();
    Hive.init(value.path);
  }

  static void registerAdapter<E>(TypeAdapter<E> adapter) {
    Hive.registerAdapter<E>(adapter);
  }

  static void registerAllAdapter() {
    final list = [HiveUserFactModelAdapter()];
    for (final i in list) {
      Hive.registerAdapter(i);
    }
  }

  static const String userDataFactsBoxName = "userDataFacts";
  static const String userDataBoxName = "userData";
  static const String pageKey = "page";
}
