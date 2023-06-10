import 'package:suns_med/shared/bloc_base.dart';

class ChoosePaymentState {
  int paymentId;
  ChoosePaymentState({this.paymentId});
}

abstract class ChoosePaymentEvent {}

class EventPayment extends ChoosePaymentEvent {
  int id;
  EventPayment({this.id});
}

class ChoosePaymentBloc
    extends BlocBase<ChoosePaymentEvent, ChoosePaymentState> {
  static final ChoosePaymentBloc _singleton = ChoosePaymentBloc._internal();

  factory ChoosePaymentBloc() {
    return _singleton;
  }

  ChoosePaymentBloc._internal();

  @override
  void initState() {
    this.state = new ChoosePaymentState();
    this.state.paymentId = 0;
    super.initState();
  }

  @override
  Future<ChoosePaymentState> mapEventToState(ChoosePaymentEvent event) async {
    if (event is EventPayment) {
      this.state = ChoosePaymentState(paymentId: event.id);
    }
    return this.state;
  }
}
