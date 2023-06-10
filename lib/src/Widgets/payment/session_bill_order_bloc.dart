import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/log_portal/payment/dto/user_wallet_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/order/dto/order_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class BillOrderState {
  OrderModelNew orderModelNew;
  UserWalletMode userWallet;
  bool checkBalance;
  BillOrderState({this.orderModelNew, this.userWallet, this.checkBalance});
}

abstract class BillOrderEvent {}

class EventGetOrder extends BillOrderEvent {
  String orderId;

  EventGetOrder({this.orderId});
}

class BillOrderBloc extends BlocBase<BillOrderEvent, BillOrderState> {
  @override
  void initState() {
    this.state = new BillOrderState();
    super.initState();
  }

  @override
  Future<BillOrderState> mapEventToState(BillOrderEvent event) async {
    if (event is EventGetOrder) {
      await _getOrder(event.orderId);
    }
    return this.state;
  }

  Future _getOrder(String orderId) async {
    final service = ServiceProxy();
    var res = await service.orderServiceProxy.getOder(orderId);
    if (res != null) {
      this.state.orderModelNew = res;
    }
  }
}
