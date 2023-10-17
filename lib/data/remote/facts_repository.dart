import 'package:dio/dio.dart';

import '../../core/api_constant.dart';
import '../../domain/model/facts_responce_model.dart';
import '../../domain/repository/remote/fact_repository.dart';

class FactsRepository implements IFactsRepository {
  final Dio _dio;
  const FactsRepository(this._dio);

  @override
  Future<List<FactsModel>> getCatFacts({int page = 1, int perPage = 20}) async {
    const path = APIConst.facts;
    final param = {"page": page, "limit": perPage};

    final res = await _dio.get(path, queryParameters: param);

    return (res.data['data'] as List)
        .map((e) => FactsModel.fromMap(e))
        .toList();
  }

  @override
  Future<FactsModel> getRandomCatFact() async {
    const path = APIConst.fact;

    final res = await _dio.get(path);
    return FactsModel.fromMap(res.data);
  }
}
