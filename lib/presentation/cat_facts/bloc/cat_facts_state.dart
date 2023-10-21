part of 'cat_facts_bloc.dart';

@immutable
sealed class CatFactsState {
  const CatFactsState();
}

sealed class CatFactsContext extends CatFactsState {
  const CatFactsContext();
}

final class CatFactsLoading extends CatFactsState {}

final class CatFactsUpdated extends CatFactsState {
  final List<UserFectMetaModel> facts;
  final bool hasNewUpdate;
  const CatFactsUpdated(this.facts, {this.hasNewUpdate = false});
}

final class ShowWarning extends CatFactsContext {
  final String message;

  const ShowWarning(this.message);
}

final class RemoveWarning extends CatFactsContext {
  const RemoveWarning();
}
