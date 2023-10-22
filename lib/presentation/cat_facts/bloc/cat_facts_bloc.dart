import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../domain/model/user_data_model.dart';
import '../../../../domain/repository/local/user_data_repository.dart';
import '../../../../domain/repository/remote/fact_repository.dart';
import '../../../core/config/helper/internet_helper.dart';
import '../../../domain/model/fact_model.dart';
import '../../../domain/repository/remote/remote_db_repository.dart';
import '../facade/cat_facts_facade.dart';

part 'cat_facts_event.dart';
part 'cat_facts_state.dart';

class CatFactsBloc extends Bloc<CatFactsEvent, CatFactsState> {
  final IFactsRepository factsRepository;
  final IUserLocalDataRepository userLocalDataRepository;
  final IRemoteUserFactsMetaRepository remoteUserDataRepository;

  final CatFactsFacade _factsFacade;

  StreamSubscription<List<FactModel>>? _factsSubscription;
  StreamSubscription<InternetConnectionStatus>? _internetSubSription;

  InternetConnectionStatus _status = InternetConnectionStatus.disconnected;

  CatFactsBloc({
    required this.factsRepository,
    required this.userLocalDataRepository,
    required this.remoteUserDataRepository,
  })  : _factsFacade = CatFactsFacade(
          factsRepository: factsRepository,
          userLocalDataRepository: userLocalDataRepository,
        ),
        super(CatFactsLoading()) {
    on<InitiateEvent>(
      (event, emit) async {
        await _initDb();
        _listenInternetActivity();
        _transferLocalDataToRemote();

        add(FetchCatFactsEvent());
      },
    );

    on<FetchCatFactsEvent>(
      (event, emit) async {
        await onFetchCatFacts(emit: emit);
      },
    );

    on<UpdateUserMetaDataEvent>(
      (event, emit) async {
        if (event.userData.duration > 0) {
          await userLocalDataRepository.addFact(event.userData);
        }
      },
      transformer: sequential(),
    );

    on<UserScrollEvent>(_onUserScrollEvent, transformer: restartable());
  }

  Future<void> onFetchCatFacts({
    required Emitter<CatFactsState> emit,
  }) async {
    await emit.onEach(
      _factsFacade.factsStream,
      onData: (data) {
        emit(CatFactsUpdated(data.$1, hasNewUpdate: data.$2));
      },
      onError: (error, stackTrace) {
        // log here
      },
    );
  }

  Future<void> _onUserScrollEvent(
      UserScrollEvent event, Emitter<CatFactsState> emit) async {
    if (_status == InternetConnectionStatus.disconnected) {
      return;
    }
    emit(const ShowWarning("Auto Facts Feed Got Stopped For a while"));
    _pauseFacts();
    await Future.delayed(const Duration(seconds: 1));
    if (emit.isDone) return;
    _startFetchingFacts();
    emit(const RemoveWarning());
  }

  Future<void> _startFetchingFacts() async {
    try {
      if (_status == InternetConnectionStatus.connected) {
        await _factsFacade.start();
        _factsSubscription?.resume();
      }
    } catch (_) {}
  }

  void _pauseFacts() {
    _factsFacade.pause();
    _factsSubscription?.pause();
  }

  Future<void> _initDb() async {
    try {
      await userLocalDataRepository.initialize();
    } catch (_) {
      // logger
    }
  }

  Future<void> _transferLocalDataToRemote() async {
    try {
      await remoteUserDataRepository.initialize();
      final list = await userLocalDataRepository.getAllFact();
      await remoteUserDataRepository.updateData(list);
      await userLocalDataRepository.deleteValues(list);
    } catch (_) {
      // catch db error
      // print("Error $_");
    }
  }

  void _listenInternetActivity() {
    InternetHelper.listen();
    _internetSubSription = InternetHelper.stream.listen((event) async {
      _status = event;
      if (event == InternetConnectionStatus.connected) {
        await _startFetchingFacts();
      } else {
        _pauseFacts();
      }
    });
  }

  @override
  Future<void> close() {
    _factsSubscription?.cancel();
    _internetSubSription?.cancel();
    _factsSubscription = null;
    _internetSubSription = null;
    _factsFacade.dispose();
    InternetHelper.stop();

    return super.close();
  }
}
