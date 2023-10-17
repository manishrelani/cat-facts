import 'package:equatable/equatable.dart';

class UserDataModel extends Equatable {
  final String fact;
  final String appearanceTime;
  final int duration;

  const UserDataModel({
    required this.fact,
    required this.appearanceTime,
    required this.duration,
  });

  Map<String, dynamic> toJson() {
    return {
      'fact': fact,
      'appearance_time': appearanceTime,
      'duration': duration
    };
  }

  @override
  List<Object?> get props => [fact, appearanceTime, duration];
}
