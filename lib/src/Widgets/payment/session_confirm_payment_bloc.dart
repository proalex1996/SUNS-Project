// import 'package:suns_med/shared/bloc_base.dart';

// class ConfirmPaymentState {}

// abstract class ConfirmPaymentEvent {}

// class EventConfirmPaymentVnPay extends ConfirmPaymentEvent {
//   String query;
//   String orderId;

//   EventConfirmPaymentVnPay({this.query, this.orderId});
// }

// class ConfirmPaymentBloc
//     extends BlocBase<ConfirmPaymentEvent, ConfirmPaymentState> {
//   @override
//   void initState() {
//     this.state = new ConfirmPaymentState();
//     super.initState();
//   }

//   @override
//   Future<ConfirmPaymentState> mapEventToState(ConfirmPaymentEvent event) {
//     if (event is EventConfirmPaymentVnPay) {
//       this.state.paid = await _confirmPaymentVnPay(event.query, event.orderId);
//       this.state.urlResult = "";
//       // } else if (event is EventResetStatePaymentMethodVnPay) {
//       //   this.state.paid = false;
//       //   this.state.orderPay = false;
//     }
//   }
// }
