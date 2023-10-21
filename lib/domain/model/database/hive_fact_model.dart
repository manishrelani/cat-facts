import 'package:hive/hive.dart';

part 'hive_fact_model.g.dart';

@HiveType(typeId: 0)
class HiveUserFactModel extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String fact;
  @HiveField(2)
  final String arrivingtime;
  @HiveField(3)
  final int duration;

  HiveUserFactModel({
    required this.id,
    required this.fact,
    required this.arrivingtime,
    required this.duration,
  });
}
