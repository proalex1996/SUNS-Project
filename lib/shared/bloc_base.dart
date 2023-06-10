import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:suns_med/shared/global_filter_error.dart';
import 'package:suns_med/shared/global_loading_state_manager.dart';


abstract class BlocBase<TEvent, TState> extends LoadingState {
  TState state;
  final _eventController = StreamController<TEvent>();
  final _stateController = StreamController<TState>();
  bool _useGlobalLoading;

  BlocBase() {
    this.initState();
  }

  Stream<TState> _stream;
  Stream<TState> get stream =>
      _stream ?? (_stream = _stateController.stream.asBroadcastStream());

  @protected
  @mustCallSuper
  void initState() {
    _useGlobalLoading = this.useGlobalLoading;
    _eventController.stream.listen((event) async {
      try {
        state = await mapEventToState(event);
        status = LoadingStatus.Done;
        _stateController.sink.add(state); // update state
      } catch (e) {
        status = LoadingStatus.Error;
        GlobalFilterError().displayError(e);
        //Todo Update log
      }
    });
  }

  Future<TState> mapEventToState(TEvent event);

  void dispatch(TEvent event, {bool reverseGlobalLoading}) {
    WidgetsBinding.instance.addPostFrameCallback((x) {
      if (reverseGlobalLoading == true) {
        var old = this._useGlobalLoading ?? false;
        this.useGlobalLoading = !old;
        status = LoadingStatus.InProgress;
        this.useGlobalLoading = old;
      } else {
        this.useGlobalLoading = this._useGlobalLoading ?? false;
        status = LoadingStatus.InProgress;
      }
      _eventController.sink.add(event);
    });
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
    // _stateLoadingController.close();
  }
}

/*
//Example
class CounterBloc extends BlocBase<int, int> {
  // static final CounterBloc _instance = CounterBloc._internal();
  // CounterBloc._internal();

  // factory CounterBloc() {
  //   return _instance;
  // }

  @override
  initState() {
    // this.useGlobalLoading = false;
    this.state = 0;
    super.initState();
  }

  @override
  Future<int> mapEventToState(int event) async {
    await Future.delayed(Duration(seconds: 2));
    // throw UnauthorizedAccessException("Test");
    return this.state += event;
  }
}
*/
