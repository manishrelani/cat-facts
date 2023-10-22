import 'dart:async';
import 'dart:math';

import 'package:pausable_timer/pausable_timer.dart';

import '../../../domain/model/fact_model.dart';
import '../../../domain/model/user_data_model.dart';
import '../../../domain/repository/local/user_data_repository.dart';
import '../../../domain/repository/remote/fact_repository.dart';

class CatFactsFacade {
  final IFactsRepository _factsRepository;
  final IUserLocalDataRepository _userLocalDataRepository;
  CatFactsFacade({
    required IFactsRepository factsRepository,
    required IUserLocalDataRepository userLocalDataRepository,
  })  : _factsRepository = factsRepository,
        _userLocalDataRepository = userLocalDataRepository;

  int _page = 1;
  int get _perPage => 30;
  int get _onUserScreen => 10;

  final StreamController<(List<UserFectMetaModel>, bool hasUpdate)>
      _factsController = StreamController();
  Stream<(List<UserFectMetaModel>, bool hasUpdate)> get factsStream =>
      _factsController.stream;

  PausableTimer? _factsTimer;
  PausableTimer? _randomFactTimer;

  final _random = Random();

  List<FactModel> _factsList = [];

  List<UserFectMetaModel> _userDataList = [];

  bool _isPaused = true;
  bool get isPaused => _isPaused;

  int get _randomValue => _random.nextInt(3) + 2;

  Future<void> _initialize() async {
    _page = await _userLocalDataRepository.getPage();
    _fetchInitialFactsDataSet();
    _startPeriodicFactsTimer();
    _startRandomTimer();
  }

  Future<void> _fetchInitialFactsDataSet() async {
    try {
      _factsList =
          await _factsRepository.getCatFacts(page: _page, perPage: _perPage);

      //suffle it so can take first n data randomly
      _factsList.shuffle(_random);

      /// take first [_onUserScreen] data and add into UserDatamodel
      for (int i = 0; (i < _onUserScreen && _factsList.length > i); i++) {
        _userDataList.add(UserFectMetaModel(
            fact: _factsList.last.fact, id: _factsList.last.id));
        _factsList.removeLast();
      }

      _factsController.add(([..._userDataList], false));

      // remove it so it will not repeat again

      // to get new facts after initial facts
      _page++;
    } catch (e, s) {
      _factsController.addError(e, s);
    }
  }

  void _startPeriodicFactsTimer() {
    int count = 0;
    _factsTimer = PausableTimer(const Duration(seconds: 5), () async {
      count++;
      _updateFacts();
      if (count == 2) {
        count = 0;
        await _addMoreFacts();

        // update page in db
      }
      if (_factsTimer != null && !_isPaused) {
        _factsTimer!
          ..reset()
          ..start();
      }
    })
      ..start();
  }

  void _startRandomTimer() {
    _randomFactTimer = PausableTimer(Duration(seconds: _randomValue), () async {
      await _updateRandomFact();
      if (!_isPaused) _startRandomTimer();
    })
      ..start();
  }

  void _resetPage() {
    _page = 1;
  }

  void _updateFacts() {
    // get random
    _factsList.shuffle(_random);

    // update the displayed facts
    final List<UserFectMetaModel> updateList = [];
    bool hasUpdate = false;
    for (int i = 0; i < _onUserScreen; i++) {
      if (_userDataList[i].hasSeen && !_userDataList[i].isSeeing) {
        // to show update
        if (i < 3) hasUpdate = true;
        updateList.add(UserFectMetaModel(
            fact: _factsList.last.fact, id: _factsList.last.id));
        _factsList.removeLast();
      } else {
        updateList.add(_userDataList[i]);
      }
    }

    _userDataList = updateList;
    _factsController.add(([..._userDataList], hasUpdate));
  }

  Future<void> _addMoreFacts() async {
    try {
      if (_factsList.length < 20) {
        final facts =
            await _factsRepository.getCatFacts(page: _page, perPage: _perPage);
        _factsList.addAll(facts);
        // check last page
        if (facts.length < _perPage) {
          _resetPage();
        } else {
          _page++;
        }
        _userLocalDataRepository.updatePage(_page);
      }
    } catch (e, s) {
      _factsController.addError(e, s);
    }
  }

  Future<void> _updateRandomFact() async {
    try {
      if (_factsList.length < 20) {
        final fact = await _factsRepository.getRandomCatFact();
        _factsList.add(fact);
      }
    } catch (e, s) {
      // log
      _factsController.addError(e, s);
    }
  }

  void pause() {
    _isPaused = true;
    _factsTimer?.pause();
    _randomFactTimer?.pause();
  }

  Future<void> start() async {
    if (!_isPaused) {
      return;
    }

    if (_factsTimer == null) {
      await _initialize();
      return;
    }

    if (_factsTimer!.isExpired) {
      _startPeriodicFactsTimer();
    } else {
      _factsTimer?.start();
    }

    if (_randomFactTimer?.isExpired ?? true) {
      _startRandomTimer();
    } else {
      _randomFactTimer?.start();
    }

    _isPaused = false;
  }

  void dispose() {
    _factsTimer?.cancel();
    _factsTimer = null;
    _randomFactTimer?.cancel();
    _randomFactTimer = null;
    _factsController.close();
  }
}
