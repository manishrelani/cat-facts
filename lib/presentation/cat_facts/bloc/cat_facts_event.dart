part of 'cat_facts_bloc.dart';

@immutable
sealed class CatFactsEvent extends Equatable {
  const CatFactsEvent();

  @override
  List<Object?> get props => [];
}

class InitiateEvent extends CatFactsEvent {}

class FetchCatFactsEvent extends CatFactsEvent {}

class UserScrollEvent extends CatFactsEvent {}

class UpdateUserDataOnFactsEvent extends CatFactsEvent {
  final UserDataModel userData;

  const UpdateUserDataOnFactsEvent(this.userData);

  @override
  List<Object?> get props => [userData];
}
