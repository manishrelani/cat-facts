part of 'cat_facts_bloc.dart';

@immutable
sealed class CatFactsState {
  const CatFactsState();
}

sealed class CatFactsContext extends CatFactsState {
  const CatFactsContext();
}

final class CatFactsLoading extends CatFactsState {}

final class CatFactsLoaded extends CatFactsState {
  final List<FactsModel> facts;
  const CatFactsLoaded(this.facts);
}

final class ShowWarning extends CatFactsContext {
  final String message;

  const ShowWarning(this.message);
}

final class RemoeWarning extends CatFactsContext {
  const RemoeWarning();
}
