import 'package:flutter/material.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/wallet_history_item.dart';
import 'package:suns_med/src/account/transactionhistory/paymentdetail_screen.dart';
import 'package:suns_med/src/account/transactionhistory/session_transactionhistory_bloc.dart';

class RechargeScreen extends StatefulWidget {
  @override
  _RechargeScreenState createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  final bloc = TransactionHistoryBloc();

  @override
  initState() {
    bloc.dispatch(LoadRechargeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getRecharge(),
    );
  }

  _getRecharge() {
    return BlocProvider<TransactionHistoryEvent, TransactionHistoryState,
        TransactionHistoryBloc>(
      bloc: bloc,
      builder: (output) {
        var checkState = output.walletHistory?.length == null;
        return checkState
            ? Container()
            : SingleChildScrollView(
                child: Wrap(
                  children: List.generate(
                    output.walletHistory?.length,
                    (index) {
                      var walletHistory = output.walletHistory[index];
                      var checkAmount = walletHistory.amount < 0;
                      return checkAmount
                          ? Container()
                          : WalletHistoryItem(
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentDetailScreen(
                                      walletHistoryModel: walletHistory,
                                    ),
                                  ),
                                );
                              },
                              title: walletHistory?.description,
                              price: walletHistory?.amount,
                              createOn: walletHistory?.createOn,
                            );
                    },
                  ),
                ),
              );
      },
    );
  }
}
