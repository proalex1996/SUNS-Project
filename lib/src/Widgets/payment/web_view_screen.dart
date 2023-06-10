import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/service_package/dto/detail_service_model.dart';
import 'package:suns_med/src/Widgets/payment/session_payment_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  final String userName, orderNo, orderId;
  final DetailServiceModel detailService;
  final double price;
  WebViewExample(
      {@required this.userName,
      this.orderNo,
      this.price,
      this.detailService,
      this.orderId});
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  final paymentBloc = PaymentBloc();
  // final confirmBloc = ConfirmBloc();

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    // confirmBloc.dispatch(EventResetStateCheckPayment());
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_sharp),
          onPressed: () {
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (ctx) => BillOrderScreen(
            //       // orderResult: paymentState.result,
            //       detailService: this.widget.detailService,
            //     ),
            //   ),
            // );
            Navigator.pop(context);
          },
        ),
        title: const Text('Thanh toán'),
        actions: <Widget>[],
      ),
      body: Builder(builder: (BuildContext context) {
        return BlocProvider<PaymentEvent, PaymentState, PaymentBloc>(
            bloc: paymentBloc,
            builder: (state) {
              return WebView(
                initialUrl: state.urlResult,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                navigationDelegate: (NavigationRequest request) async {
                  var a = Uri.parse(request.url);
                  a.queryParameters;
                  if (a.queryParameters.containsKey("vnp_TransactionNo")) {
                    print('blocking navigation to $request}');
                    paymentBloc.dispatch(EventConfirmPaymentVnPay(
                        query: a.query, orderId: widget.orderId));

                    Navigator.pop(context);
                  } else if (request.url.startsWith("momo://?") ||
                      request.url.contains("momo.vn/download")) {
                    await _launchInBrowser(request.url);
                  }
                  print('allowing navigation to $request');
                  return NavigationDecision.navigate;
                },
                onPageStarted: (String url) {
                  // print('Page started loading: $url');
                },
                onPageFinished: (String url) {
                  print('Page finished loading: $url');
                },
                gestureNavigationEnabled: true,
              );
            });
      }),
      // floatingActionButton: favoriteButton(),
    );
  }
}
