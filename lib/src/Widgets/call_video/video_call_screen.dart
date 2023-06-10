import 'dart:core';

import 'package:flutter/material.dart';
import 'package:suns_med/src/Widgets/call_video/src/call_screen.dart';

import 'src/get_display_media_sample.dart';
import 'src/get_user_media_sample.dart'
    if (dart.library.html) 'src/get_user_media_sample_web.dart';
import 'src/loopback_sample.dart';
import 'src/route_item.dart';

class VideoCallScreen extends StatefulWidget {
  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  List<RouteItem> items;

  @override
  void initState() {
    super.initState();
    _initItems();
  }

  ListBody _buildRow(context, item) {
    return ListBody(children: <Widget>[
      ListTile(
        title: Text(item.title),
        onTap: () => item.push(context),
        trailing: Icon(Icons.arrow_right),
      ),
      Divider()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter-WebRTC example'),
        ),
        body: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0.0),
            itemCount: items.length,
            itemBuilder: (context, i) {
              return _buildRow(context, items[i]);
            }));
  }

  void _initItems() {
    items = <RouteItem>[
      RouteItem(
          title: 'GetUserMedia',
          push: (BuildContext context) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => GetUserMediaSample()));
          }),
      RouteItem(
          title: 'GetDisplayMedia',
          push: (BuildContext context) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        GetDisplayMediaSample()));
          }),
      RouteItem(
          title: 'LoopBack Sample',
          push: (BuildContext context) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LoopBackSample()));
          }),
      RouteItem(
          title: 'VideoCall',
          push: (BuildContext context) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => CallScreen(
                          ip: 'http://192.168.1.5:3000',
                        )));
          }),
    ];
  }
}
