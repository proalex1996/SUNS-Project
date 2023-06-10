import 'package:flutter/material.dart';

class InforItem extends StatefulWidget {
  final Function onPress;
  final String image;
  final String name;
  final String birthday;
  final String gender;
  final String phone;
  final String email;
  final String personalNumber;
  InforItem({
    this.image,
    this.onPress,
    this.name,
    this.birthday,
    this.gender,
    this.phone,
    this.email,
    this.personalNumber,
  });
  @override
  _InforItemState createState() => _InforItemState();
}

class _InforItemState extends State<InforItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress,
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(left: 21, top: 10, bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              widget.image,
              width: 53,
              height: 53,
            ),
            SizedBox(
              width: 15,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        widget.birthday,
                        style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 16,
                        ),
                      ),
                      Text(" - "),
                      Text(
                        widget.gender,
                        style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.phone,
                    style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    widget.email,
                    style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    widget.personalNumber,
                    style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
