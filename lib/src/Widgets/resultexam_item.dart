import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/src/contacts/appointmenthistory/xray_screen.dart';

class ResultExamItem extends StatelessWidget {
  final String serviceName;
  final String doctorName;
  final String rusult;
  final String note;

  const ResultExamItem(
      {Key key, this.serviceName, this.doctorName, this.rusult, this.note})
      : super(key: key);

  Future _showAlert(BuildContext context, String message) async {
    return showDialog(
        context: context,
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: _buildDialog(context),
        ));
  }

  _buildDialog(context) => Container(
        padding: const EdgeInsets.all(10),
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Ghi chú:',
                style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: 16,
                    color: AppColor.pumpkin)),
            SizedBox(
              height: 10,
            ),
            Text(
              '- Lưu ý khi ăn uống',
              style: TextStyle(
                  fontFamily: 'Montserrat-M',
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 282,
              child: Text(
                note,
                style: TextStyle(
                    fontFamily: 'Montserrat-M', fontSize: 13, height: 1.5),
              ),
            ),
          ],
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: const EdgeInsets.only(left: 20, top: 15, right: 20),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Tên dịch vụ: ',
                  style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  serviceName,
                  style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  'Tên bác sĩ: ',
                  style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  doctorName,
                  style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kết quả: ',
                  style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 285,
                  child: Text(
                    rusult,
                    style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => _showAlert(context, 'message'),
                  child: Image.asset(
                    'assets/images/ghichu.png',
                    width: 88,
                    height: 18,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => XRayScreen()));
                  },
                  child: Image.asset(
                    'assets/images/search2.png',
                    width: 20,
                    height: 21,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
