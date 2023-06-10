import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/service_proxy/log_portal/payment/dto/wallet_history_model.dart';

class PaymentDetailScreen extends StatelessWidget {
  final WalletHistoryModel walletHistoryModel;

  const PaymentDetailScreen({
    Key key,
    this.walletHistoryModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final money = NumberFormat('#,###,000');
    String date = walletHistoryModel?.createOn;
    DateTime dateTime = DateTime.parse(date);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.deepBlue,
        title: Text(
          'Chi tiết thanh toán',
          style: TextStyle(
              fontFamily: 'Montserrat-M', fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
                left: 51, right: 50.8, top: 24.5, bottom: 34.6),
            child: Image.asset(
              'assets/images/payment.png',
              height: 209,
              width: double.infinity,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 14),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColor.deepBlue,
                  minRadius: 4,
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  walletHistoryModel?.description,
                  style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 15, right: 14, top: 15, bottom: 15),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColor.deepBlue,
                  minRadius: 4,
                ),
                SizedBox(
                  width: 15,
                ),
                Row(
                  children: [
                    Text(
                      'Số tiền thanh toán: ',
                      style:
                          TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          "${money.format(walletHistoryModel?.amount ?? 0)}",
                          style: TextStyle(
                              fontFamily: 'Montserrat-M', fontSize: 16),
                        ),
                        Text(
                          ' VND',
                          style: TextStyle(
                              fontFamily: 'Montserrat-M', fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 14, bottom: 16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColor.deepBlue,
                  minRadius: 4,
                ),
                SizedBox(
                  width: 15,
                ),
                Row(
                  children: [
                    Text(
                      'Mã booking: ',
                      style:
                          TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                    ),
                    Text(
                      walletHistoryModel?.id.toString(),
                      style:
                          TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 17, bottom: 46),
            alignment: Alignment.centerRight,
            child: Text(
              DateFormat.yMd('vi').add_Hms().format(dateTime),
              style: TextStyle(
                  fontFamily: 'Montserrat-M',
                  fontSize: 13,
                  color: AppColor.veryLightPinkTwo),
            ),
          ),
          Container(
            child: Text(
              'Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi !',
              style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
