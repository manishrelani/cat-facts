import 'dart:async';
import 'dart:math';

import 'package:pausable_timer/pausable_timer.dart';

import '../../../domain/model/facts_responce_model.dart';
import '../../../domain/repository/local/user_data_repository.dart';
import '../../../domain/repository/remote/fact_repository.dart';

class CatFactsFacade {
  final IFactsRepository _factsRepository;
  final IUSerDataRepository _localUserDataRepository;
  CatFactsFacade({
    required IFactsRepository factsRepository,
    required IUSerDataRepository localUserDataRepository,
  })  : _factsRepository = factsRepository,
        _localUserDataRepository = localUserDataRepository;

  int _page = 1;

  final int _elementLength = 4;
  late final int _perPage = _elementLength * 2;

  final StreamController<List<FactsModel>> _factsController =
      StreamController();
  Stream<List<FactsModel>> get factsStream => _factsController.stream;

  PausableTimer? _factsTimer;
  PausableTimer? _randomFactTimer;

  final _random = Random();

  // to store whole api data, then update the set after 5 sec
  List<FactsModel> _factsList = [];
  // using for random fact, so we can add random fact into existing list
  List<FactsModel> _lastFactList = [];

  bool _isPaused = true;

  int get _randomValue => _random.nextInt(3) + 2;

  bool get _isLastPage => _factsList.length < _perPage;

  bool get isPaused => _isPaused;

  Future<void> initialize() async {
    _page = await _localUserDataRepository.getPage();
    _resetData();
  }

  Future<void> _fetchFactData() async {
    await _getCatFacts();
    _updateSetOfFacts();
    _startFactTimer();
    _startRandomTimer();
    _isPaused = false;
  }

  void _resetData() {
    _factsTimer?.cancel();
    _factsTimer?.cancel();
    _factsList.clear();
    _lastFactList.clear();
  }

  void _startFactTimer() {
    int count = 0;
    _factsTimer = PausableTimer(const Duration(seconds: 5), () async {
      count++;
      if (count == 1) {
        _updateSetOfFacts();
      } else if (count == 2) {
        _page++;
        count = 0;

        await _getCatFacts();
        _updateSetOfFacts();

        // update page in db
        _localUserDataRepository.updatePage(_page);
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

  Future<void> _getCatFacts() async {
    try {
      _factsList =
          await _factsRepository.getCatFacts(page: _page, perPage: _perPage);
      if (_isLastPage) _resetPage();
    } catch (e, s) {
      // log
      _factsController.addError(e, s);
    }
  }

  void _resetPage() {
    _page = 1;
  }

  void _updateSetOfFacts() {
    if (_factsList.isEmpty) {
      return;
    }

    if (_factsList.length <= _elementLength) {
      _factsController.add([..._factsList]);
      _lastFactList = [..._factsList];
      _factsList.clear();
    } else {
      _factsList.shuffle(_random);
      final list = _factsList.sublist(0, _elementLength);
      _lastFactList = [...list];
      _factsController.add([...list]);
      _factsList.removeRange(0, _elementLength);
    }
  }

  Future<void> _updateRandomFact() async {
    try {
      final fact = await _factsRepository.getRandomCatFact();
      if (!_lastFactList.any((element) => element.fact == fact.fact)) {
        _lastFactList.add(fact);
        _factsController.add([..._lastFactList]);
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
      await _fetchFactData();
      return;
    }

    if (_factsTimer!.isExpired) {
      _startFactTimer();
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
