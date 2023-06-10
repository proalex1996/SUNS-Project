import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/Bottombar/navigator_bar.dart';
import 'package:suns_med/src/account/session_topup_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebUrlRechargeExample extends StatefulWidget {
  @override
  _WebUrlRechargeExampleState createState() => _WebUrlRechargeExampleState();
}

class _WebUrlRechargeExampleState extends State<WebUrlRechargeExample> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  final bloc = ChooseTopupBloc();

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
    bloc.dispatch(EventResetStateReCharge());
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomBar(),
                ),
                (route) => false);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: <Widget>[],
      ),
      body: Builder(builder: (BuildContext context) {
        return BlocProvider<ChooseTopupEvent, ChooseTopupState,
                ChooseTopupBloc>(
            bloc: bloc,
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
                    bloc.dispatch(EventConfirmReChargeVnPay(query: a.query));
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
