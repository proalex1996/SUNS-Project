import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';

class WebViewUrlPolicy extends StatefulWidget {
  final String url;
  WebViewUrlPolicy({this.url});
  @override
  _WebViewUrlPolicyState createState() => _WebViewUrlPolicyState();
}

class _WebViewUrlPolicyState extends State<WebViewUrlPolicy> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Điều khoản sử dụng',
        titleSize: 18,
        isTopPadding: false,
      ),
      // AppBar(
      //   backgroundColor: AppColor.deepBlue,
      //   centerTitle: true,
      //   title: const Text('Chính sách sử dụng'),
      //   actions: <Widget>[],
      // ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          navigationDelegate: (NavigationRequest request) async {
            // var a = Uri.parse(request.url);
            // a.queryParameters;
            // if (a.queryParameters.containsKey("vnp_TransactionNo")) {
            //   print('blocking navigation to $request}');
            //   Navigator.pop(context);
            // } else if (request.url.startsWith("momo://?") ||
            //     request.url.contains("momo.vn/download")) {
            //   await _launchInBrowser(request.url);
            // }
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
      }),
      // floatingActionButton: favoriteButton(),
    );
  }
}
