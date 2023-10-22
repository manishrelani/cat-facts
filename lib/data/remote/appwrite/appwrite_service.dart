import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

import '../../../domain/model/user_data_model.dart';
import '../../../domain/repository/remote/remote_db_repository.dart';

class AppWriteRemoteService extends IRemoteUserFactsMetaRepository {
  Databases? _db;
  User? _user;

  @override
  Future<void> initialize() async {
    Client client = Client();

    client
        .setEndpoint(AppwriteDatabaseHelper.endPoint)
        .setProject(AppwriteDatabaseHelper.projectId)
        .setSelfSigned();

    final ac = Account(client);
    _db = Databases(client);

    try {
      await ac.getSession(sessionId: 'current');
    } on AppwriteException {
      final session = await ac.createAnonymousSession();
      ac.updatePrefs(prefs: {
        "deviceBrand": session.deviceBrand,
        "deviceModel": session.deviceModel,
        "deviceName": session.deviceName,
        "ip": session.ip,
        "countryName": session.countryName,
        "userId": session.userId,
        "clientName": session.clientName,
      });
    }
    _user = await ac.get();
  }

  @override
  Future<void> updateData(List<UserFectMetaModel> value) async {
    for (var i in value) {
      final data = {...i.toJson(), 'user_id': _user!.$id};

      await _db?.createDocument(
        databaseId: AppwriteDatabaseHelper.dbId,
        collectionId: AppwriteDatabaseHelper.collectionId,
        documentId: "${i.id}",
        data: data,
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
