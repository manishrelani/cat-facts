import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cat_facts/domain/repository/remote/remote_db_repository.dart';
import 'package:cat_facts/util/internet_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../domain/model/facts_responce_model.dart';
import '../../../../domain/model/user_data_model.dart';
import '../../../../domain/repository/local/user_data_repository.dart';
import '../../../../domain/repository/remote/fact_repository.dart';
import '../facade/cat_facts_facade.dart';

part 'cat_facts_event.dart';
part 'cat_facts_state.dart';

class CatFactsBloc extends Bloc<CatFactsEvent, CatFactsState> {
  final IFactsRepository factsRepository;
  final IUSerDataRepository localUserDataRepository;
  final IRemoteUserDataRepository remoteUserDataRepository;

  final CatFactsFacade _factsFacade;

  StreamSubscription<List<FactsModel>>? _factsSubscription;
  StreamSubscription<InternetConnectionStatus>? _internetSubSription;

  CatFactsBloc({
    required this.factsRepository,
    required this.localUserDataRepository,
    required this.remoteUserDataRepository,
  })  : _factsFacade = CatFactsFacade(
          factsRepository: factsRepository,
          localUserDataRepository: localUserDataRepository,
        ),
        super(CatFactsLoading()) {
    on<InitiateEvent>(
      (event, emit) async {
        await localUserDataRepository.initialize();
        await _factsFacade.initialize();
        _listenInternetActivity();
        _updateAllLocalData();

        add(FetchCatFactsEvent());
      },
    );

    on<FetchCatFactsEvent>(
      (event, emit) async {
        try {
          await onFetchCatFacts(emit: emit);
        } catch (_) {
          // log here
        }
      },
    );

    on<UpdateUserDataOnFactsEvent>(
      (event, emit) async {
        await localUserDataRepository.addFact(event.userData);
      },
      transformer: sequential(),
    );

    on<UserScrollEvent>(
      _onUserScrollEvent,
      transformer: restartable(),
    );
  }

  Future<void> onFetchCatFacts({
    required Emitter<CatFactsState> emit,
  }) async {
    await emit.onEach(
      _factsFacade.factsStream,
      onData: (data) {
        emit(CatFactsLoaded(data));
      },
      onError: (error, stackTrace) {
        // do something
      },
    );
  }

  Future<void> _onUserScrollEvent(
      UserScrollEvent event, Emitter<CatFactsState> emit) async {
    print(1);
    emit(const ShowWarning("Auto Facts Feed Got Stopped For a while"));
    _pauseFacts();
    await Future.delayed(const Duration(seconds: 1));
    if (emit.isDone) return;
    _startFetchingFacts();
    emit(const RemoveWarning());
  }

  Future<void> _startFetchingFacts() async {
    try {
      await _factsFacade.start();
      _factsSubscription?.resume();
    } catch (_) {
      // log here
    }
  }

  void _pauseFacts() {
    _factsFacade.pause();
    _factsSubscription?.pause();
  }

  Future<void> _updateAllLocalData() async {
    try {
      await remoteUserDataRepository.initialize();
      final list = await localUserDataRepository.getAllFact();
      await remoteUserDataRepository.updateData(list);
      await localUserDataRepository.deleteDb();
    } catch (_) {
      // catch db error
      // print("Error $_");
    }
  }

  void _listenInternetActivity() {
    InternetHelper.init();
    _internetSubSription = InternetHelper.stream.listen((event) async {
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
    return super.close();
  }
}
