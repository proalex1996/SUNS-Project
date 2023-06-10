import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/log_portal/payment/dto/wallet_history_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class TransactionHistoryState {
  List<WalletHistoryModel> walletHistory;
  TransactionHistoryState({this.walletHistory});
}

abstract class TransactionHistoryEvent {}

class LoadRechargeEvent extends TransactionHistoryEvent {}

class LoadMedical extends TransactionHistoryEvent {}

class TransactionHistoryBloc
    extends BlocBase<TransactionHistoryEvent, TransactionHistoryState> {
  @override
  void initState() {
    this.state = new TransactionHistoryState();
    super.initState();
  }

  @override
  Future<TransactionHistoryState> mapEventToState(
      TransactionHistoryEvent event) async {
    if (event is LoadRechargeEvent) {
      await _getRecharge();
    }

    if (event is LoadMedical) {
      await _getMedical();
    }
    return this.state;
  }

  Future _getRecharge() async {
    final service = ServiceProxy().paymentServiceProxy;
    this.state.walletHistory = await service.getWalletHistory();
  }

  Future _getMedical() async {
    final service = ServiceProxy().paymentServiceProxy;
    this.state.walletHistory = await service.getWalletHistory();
  }
}
