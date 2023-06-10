import 'package:suns_med/shared/bloc_base.dart';

class ChooseTimeState {
  int index;
  ChooseTimeState({this.index});
}

abstract class ChooseTimeEvent {}

class EventChoose extends ChooseTimeEvent {
  int index;
  EventChoose({this.index});
}

class ChooseTimeBloc extends BlocBase<ChooseTimeEvent, ChooseTimeState> {
  @override
  void initState() {
    this.state = new ChooseTimeState();
    this.state.index = 0;
    super.initState();
  }

  @override
  Future<ChooseTimeState> mapEventToState(ChooseTimeEvent event) async {
    if (event is EventChoose) {
      this.state.index = event.index;
    }
    return this.state;
  }
}
