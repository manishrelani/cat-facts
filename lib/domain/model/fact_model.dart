import 'package:equatable/equatable.dart';

class FactModel extends Equatable {
  final String fact;
  final int id;
  FactModel({required this.fact, int? id}) : id = id ?? fact.hashCode;

  factory FactModel.fromMap(Map<String, dynamic> json) =>
      FactModel(fact: json["fact"], id: json['id']);

  Map<String, dynamic> toMap() => {"fact": fact, "id": id};

  @override
  List<Object?> get props => [fact, id];

  @override
  String toString() {
    return "FactModel(fact: $fact, id: $id)";
  }
}
