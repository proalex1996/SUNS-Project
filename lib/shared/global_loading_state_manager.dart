import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:suns_med/shared/app_config.dart';


enum LoadingStatus { InProgress, Done, Error }

class LoadingState {
  bool useGlobalLoading = true;
  LoadingStatus _status = LoadingStatus.Done;

  LoadingStatus get status => _status;

  set status(LoadingStatus status) {
    var old = _status;
    _status = status;
    _updateStateLoading(old, status);
  }

  @protected
  void _updateStateLoading(LoadingStatus oldStatus, LoadingStatus newStatus) {
    if (newStatus == LoadingStatus.InProgress) {
      GlobalLoadingStateManager().start(this);
    } else {
      GlobalLoadingStateManager().stop(this);
    }
  }
}

class GlobalLoadingStateManager {
  OverlayEntry _progressOverlayEntry;
  final _queue = Queue<LoadingState>();
  // final timeout = TimeoutHandler()
  static final GlobalLoadingStateManager _instance =
      GlobalLoadingStateManager._internal();
  GlobalLoadingStateManager._internal();

  factory GlobalLoadingStateManager() {
    return _instance;
  }

  void start(LoadingState loadingState) {
    if (!loadingState.useGlobalLoading ||
        loadingState.status != LoadingStatus.InProgress) {
      return;
    }

    if (!_queue.any((element) => element == loadingState)) {
      _queue.add(loadingState);
      _showLoading();
    }
  }

  void stop(LoadingState loadingState) {
    var result = false;
    try {
      result = _queue.remove(loadingState);
    } catch (e) {}

    if (!result && _queue.isNotEmpty) {
      _queue.clear();
    }

    if (_queue.isEmpty) {
      _stopLoading();
    }
    //Todo udpate timeout stop loading trong trường hợp bị dispose không kiểm soát
  }

  _stopLoading() {
    if (_progressOverlayEntry != null) {
      _progressOverlayEntry.remove();
      _progressOverlayEntry = null;
    }
  }

  _showLoading() {
    if (_progressOverlayEntry == null) {
      var overlay = AppConfig().navigatorKey.currentState.overlay;

      if (overlay?.context != null) {
        _progressOverlayEntry = _createdProgressEntry(overlay.context);
        overlay.insert(_progressOverlayEntry);
      }
    }
  }

  OverlayEntry _createdProgressEntry(BuildContext context) => OverlayEntry(
        builder: (BuildContext context) => Container(
          color: Colors.black12,//Theme.of(context).dialogTheme.,
          child: AppConfig().loading,
        ),
      );
}
