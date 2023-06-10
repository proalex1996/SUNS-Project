import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';

class InCommingCall extends StatefulWidget {
  const InCommingCall({Key key}) : super(key: key);

  @override
  _InCommingCallState createState() => _InCommingCallState();
}

class _InCommingCallState extends State<InCommingCall> {
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.deepBlue,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  // SizedBox(
                  //   height: 10,
                  // ),
                  CircleAvatar(
                    minRadius: 80,
                    backgroundColor: Colors.blue.shade300,
                    child: Text("NA"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Name",
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "SUNS: Cuộc gọi đến",
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        // fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        minRadius: 30,
                        backgroundColor: Colors.red.shade400,
                        child: Icon(Icons.call_end),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Từ chối",
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            // fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        minRadius: 30,
                        backgroundColor: Colors.green.shade400,
                        child: Icon(Icons.video_call, color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Trả lời",
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            // fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
