import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';

class OutCommingCall extends StatefulWidget {
  const OutCommingCall({Key key}) : super(key: key);

  @override
  _OutCommingCallState createState() => _OutCommingCallState();
}

class _OutCommingCallState extends State<OutCommingCall> {
  @override
  Widget build(BuildContext context) {
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
                    "SUNS: Đang đổ chuông",
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        // fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    minRadius: 30,
                    backgroundColor: Colors.white70,
                    child: Icon(Icons.menu, color: Colors.white),
                  ),
                  CircleAvatar(
                    minRadius: 30,
                    backgroundColor: Colors.red.shade400,
                    child: Icon(Icons.call_end),
                  ),
                  CircleAvatar(
                    minRadius: 30,
                    backgroundColor: Colors.white70,
                    child: Icon(Icons.mic, color: Colors.white),
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
