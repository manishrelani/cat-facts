import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

import '../../../domain/model/user_data_model.dart';
import '../../../domain/repository/remote/remote_db_repository.dart';

class AppWriteRemoteService extends IRemoteUserFactsMetaRepository {
  Databases? _db;
  Session? _session;

  @override
  Future<void> initialize() async {
    Client client = Client();

    client
        .setEndpoint(AppwriteDatabaseHelper.endPoint)
        .setProject(AppwriteDatabaseHelper.projectId)
        .setSelfSigned();
    _db = Databases(client);

    final ac = Account(client);

    try {
      _session = await ac.getSession(sessionId: 'current');
    } on AppwriteException {
      _session = await ac.createAnonymousSession();
    }

    ac.updatePrefs(prefs: {
      "deviceBrand": _session?.deviceBrand,
      "deviceModel": _session?.deviceModel,
      "deviceName": _session?.deviceName,
      "ip": _session?.ip,
      "countryName": _session?.countryName,
      "userId": _session?.userId,
      "clientName": _session?.clientName,
    });
  }

  @override
  Future<void> updateData(List<UserFectMetaModel> value) async {
    for (var i in value) {
      await _db?.createDocument(
        databaseId: AppwriteDatabaseHelper.dbId,
        collectionId: AppwriteDatabaseHelper.collectionId,
        documentId: "${i.id}",
        data: i.toJson(),
      );
    }
  }
}

class AppwriteDatabaseHelper {
  AppwriteDatabaseHelper._();

  static const String dbId = '652e0abcddd5a7d47448';
  static const String collectionId = '652e0ad4ad3a1489353d';
  static const String endPoint = 'https://cloud.appwrite.io/v1';
  static const String projectId = '652b0faaba3e54437319';
}
