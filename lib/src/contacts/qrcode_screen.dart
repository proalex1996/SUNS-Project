import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/contact_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:suns_med/common/dimension.dart';

class QRCodeScreen extends StatefulWidget {
  final ContactModel qrcodeModel;

  const QRCodeScreen({Key key, this.qrcodeModel}) : super(key: key);
  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'QR Code',
        titleSize: 18,
        isTopPadding: false,
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/background.png',
            width: width(context),
            height: height(context),
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 35, bottom: 46.6),
                  child: Text(
                    '${AppLocalizations.of(context).scan} QR Code ',
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 16,
                        color: AppColor.darkPurple,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                QrImage(
                  data: widget.qrcodeModel.barcode,
                  version: QrVersions.auto,
                  size: 250,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
