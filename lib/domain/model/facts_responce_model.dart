import 'package:equatable/equatable.dart';

class FactsModel extends Equatable {
  final String fact;

  const FactsModel({required this.fact});

  factory FactsModel.fromMap(Map<String, dynamic> json) => FactsModel(
        fact: json["fact"],
      );

  Map<String, dynamic> toMap() => {
        "fact": fact,
      };

  @override
  List<Object?> get props => [fact];
}
