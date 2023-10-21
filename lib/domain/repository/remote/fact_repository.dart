import '../../model/fact_model.dart';

abstract class IFactsRepository {
  Future<List<FactModel>> getCatFacts({int page = 1, int perPage = 20});
  Future<FactModel> getRandomCatFact();
}
