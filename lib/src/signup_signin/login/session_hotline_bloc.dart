import 'package:flutter/material.dart';
import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class HotlineState {
  String hotline;
}

abstract class HotlineEvent {}

class EventGetHotline extends HotlineEvent {}

class HotlineBloc extends BlocBase<HotlineEvent, HotlineState> {
  @override
  void initState() {
    this.state = HotlineState();
    super.initState();
  }

  @override
  Future<HotlineState> mapEventToState(HotlineEvent event) async {
    if (event is EventGetHotline) {
      await _getHotline();
    }
    return this.state;
  }

  Future _getHotline() async {
    final service = ServiceProxy().newCommonServiceProxy;
    var res = await service.getHotline();
    this.state.hotline = res;
  }
}
