import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DoctorWidget extends StatelessWidget {
  final String avatar;
  final Widget name;
  final Color color;
  final Function onTap;
  const DoctorWidget({Key key, this.avatar, this.name, this.color, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context);
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 120,
        ),
        Container(
            margin: EdgeInsets.only(top: 35, right: 5),
            height: 144,
            width: 156,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.lightGray),
                color: Colors.white)),
        Container(
          width: 68,
          height: 68,

          decoration: BoxDecoration(shape: BoxShape.circle),
          //padding: const EdgeInsets.all(3),
          child: CircleAvatar(
            maxRadius: 50,
            backgroundColor: Colors.white,
            //child: ClipOval(
            backgroundImage: (this?.avatar == null)
                ? AssetImage("assets/images/avatar2.png")
                : NetworkImage("${this?.avatar}"),
            // )
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 80),
          child: Column(
            children: [
              this.name,
              SizedBox(
                height: 4,
              ),
              Text(
                language.specialist,
                style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: 14,
                    color: AppColor.warmGrey),
              ),
              InkWell(
                  onTap: onTap,
                  child: Container(
                    margin: EdgeInsets.only(top: 17),
                    height: 28,
                    width: 110,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15), color: color),
                    child: Center(
                      child: Text(
                        language.selectDoctor,
                        style: TextStyle(
                            // fontFamily: 'Montserrat-M',
                            color: Colors.white,
                            fontSize: 12),
                        // textAlign: TextAlign.center,
                      ),
                    ),
                  ))
            ],
          ),
        )
      ],
    );
  }
}
