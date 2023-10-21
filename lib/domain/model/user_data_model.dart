class UserFectMetaModel {
  final String fact;
  final int id;
  // in Iso8601String Formate
  String? _appearanceTime;
  // in seconds
  int _duration = 0;
  bool isSeeing = false;

  UserFectMetaModel({
    required this.fact,
    required this.id,
    String? appearanceTime,
    int duration = 0,
  })  : _duration = duration,
        _appearanceTime = appearanceTime;

  set appearanceTime(String? time) {
    _appearanceTime ??= time;
  }

  set duration(int duration) {
    _duration += duration;
  }

  bool get hasSeen => _duration > 0;

  String? get appearanceTime => _appearanceTime;
  int get duration => _duration;

  Map<String, dynamic> toJson() {
    return {
      'fact': fact,
      'appearance_time': _appearanceTime,
      'duration': _duration,
    };
  }

  UserFectMetaModel copyWith(
      {String? fact, int? id, String? appearanceTime, int? duration}) {
    return UserFectMetaModel(
      fact: fact ?? this.fact,
      id: id ?? this.id,
      appearanceTime: appearanceTime ?? _appearanceTime,
      duration: duration ?? _duration,
    );
  }

  @override
  String toString() {
    return 'UserFectMetaModel(id: $id, fact:$fact, appearanceTime: $_appearanceTime, duration: $_duration)';
  }
}
