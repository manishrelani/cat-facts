import '../../model/facts_responce_model.dart';

abstract class IFactsRepository {
  Future<List<FactsModel>> getCatFacts({int page = 1, int perPage = 20});
  Future<FactsModel> getRandomCatFact();
}
