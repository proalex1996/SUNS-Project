import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppointmentHistoryItem extends StatelessWidget {
  final String fullName;
  final String id;
  final String appointDate;
  final String clinicName;
  final String relationShip;
  final Function onPress;

  const AppointmentHistoryItem(
      {Key key,
      this.fullName,
      this.onPress,
      this.id,
      this.appointDate,
      this.clinicName,
      this.relationShip})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          border: Border.all(color: AppColor.pinkishGrey),
        ),
        padding:
            const EdgeInsets.only(top: 13, left: 14, bottom: 13, right: 14),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName,
                  style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColor.deepBlue,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${language.code} Booking:',
                      style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      id ?? "",
                      style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${language.dateOfExamination}:',
                      style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      appointDate,
                      style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${language.doctor}:',
                      style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      clinicName ?? "",
                      style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
