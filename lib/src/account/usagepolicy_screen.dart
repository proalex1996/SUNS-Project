import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/account/session_usagepolicy_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class UsagePolicyScreen extends StatefulWidget {
  @override
  _UsagePolicyScreenState createState() => _UsagePolicyScreenState();
}

class _UsagePolicyScreenState extends State<UsagePolicyScreen> {
  final bloc = PolicyBloc();

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  void initState() {
    bloc.dispatch(EventGetData());
    _launchURL(bloc.state.data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.deepBlue,
        title: Text(
          'Chính sách sử dụng',
          style: TextStyle(
              fontFamily: 'Montserrat-M', fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: BlocProvider<PolicyEvent, PolicyState, PolicyBloc>(
        bloc: bloc,
        builder: (state) {
          return Container(
            child: Text("${state.data}"),
          );
        },
      ),
    );
  }
}
