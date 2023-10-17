import 'dart:async';

import 'package:appwrite/appwrite.dart';

import '../../../domain/model/user_data_model.dart';
import '../../../domain/repository/remote/remote_db_repository.dart';

class AppWriteRemoteService extends IRemoteUserDataRepository {
  Databases? _db;

  @override
  Future<void> initialize() async {
    Client client = Client();

    client
        .setEndpoint(AppwriteDatabaseHelper.endPoint)
        .setProject(AppwriteDatabaseHelper.projectId)
        .setSelfSigned();
    _db = Databases(client);
    final ac = Account(client);

    await ac.createAnonymousSession();

    await ac.getSession(sessionId: 'current');
  }

  @override
  Future<void> updateData(List<UserDataModel> value) async {
    for (var i in value) {
      await _db?.createDocument(
        databaseId: AppwriteDatabaseHelper.dbId,
        collectionId: AppwriteDatabaseHelper.collectionId,
        documentId: ID.unique(),
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
