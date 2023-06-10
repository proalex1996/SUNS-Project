import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/account/medicalrecord/update-contact.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/contact_model.dart';
import 'package:suns_med/src/product/service-package-list.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class ContactItem extends StatefulWidget {
  final Function press;
  final ContactModel contactModel;
  final String relationShip;
  ContactItem({this.press, this.contactModel, this.relationShip});

  @override
  _ContactItemState createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  @override
  Widget build(BuildContext context) {
    // String date = widget.birthay;
    // DateTime dateTime = DateTime.parse(date);
    return GestureDetector(
        onTap: widget.press,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                    height: 22,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.only(top: 9, left: 20, bottom: 9),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                        color: Colors.transparent)),
                Container(
                  height: 246,
                  margin: EdgeInsets.only(bottom: 22),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        width: 86,
                        height: 86,
                        margin: EdgeInsets.only(left: 18),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        padding: const EdgeInsets.all(4),
                        child: CircleAvatar(
                            maxRadius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                AssetImage("assets/images/avatar2.png"))),
                    Container(
                      height: 41,
                      margin: EdgeInsets.only(left: 26, top: 35),
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8),
                      //     color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget?.contactModel?.fullName,
                              style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                color: AppColor.darkPurple,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text(
                              '${AppLocalizations.of(context).relationship}: ${widget?.relationShip}',
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: 14,
                                  color: AppColor.warmGrey)),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 81,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(13, 13, 13, 18),
                  padding: EdgeInsets.fromLTRB(13, 3, 13, 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColor.lightGray),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _email(),
                      Text(
                        widget?.contactModel?.birthDay == null
                            ? '${AppLocalizations.of(context).notEnter}${AppLocalizations.of(context).dob}'
                            : DateFormat.yMd("vi_VN").format(
                                widget?.contactModel?.birthDay,
                              ),
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 14,
                            color: AppColor.warmGrey),
                      ),
                      Text(
                        widget?.contactModel?.id == null
                            ? '${AppLocalizations.of(context).profileID} ${AppLocalizations.of(context).notEnter}'
                            : '${AppLocalizations.of(context).profileID} ${widget?.contactModel?.id}',
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 14,
                            color: AppColor.warmGrey),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateContactScreen(
                              contact: widget?.contactModel,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        width: 126,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: AppColor.warmGrey),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).update,
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 14,
                                color: AppColor.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ServicePackageList(
                                      contact: widget?.contactModel,
                                    )));
                      },
                      child: Container(
                        height: 50,
                        width: 170,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: AppColor.purple),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/Calendar2.png'),
                              // SvgPicture.asset('assets/Svg/Calendar2.svg'),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                AppLocalizations.of(context).book,
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 14,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        )
        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Row(
        //       children: [],
        //     ),
        //     widget.name == null
        //         ? Shimmer.fromColors(
        //             child: Container(
        //               width: 136,
        //               height: 17,
        //             ),
        //             baseColor: AppColor.paleGreyFour,
        //             highlightColor: AppColor.whitetwo,
        //           )
        //         : Text(
        //             widget.name,
        //             style:TextStyle(
        //               fontFamily: 'Montserrat-M',
        //                 color: AppColor.deepBlue,
        //                 fontSize: 16,
        //                 fontWeight: FontWeight.bold),
        //           ),
        //     SizedBox(
        //       height: 5,
        //     ),
        //     widget.relationship == null
        //         ? Shimmer.fromColors(
        //             child: Container(
        //               width: 136,
        //               height: 17,
        //             ),
        //             baseColor: AppColor.paleGreyFour,
        //             highlightColor: AppColor.whitetwo,
        //           )
        //         : Row(
        //             children: [
        //               Text(
        //                 'Mối quan hệ: ',
        //                 style:TextStyle(
        //       fontFamily: 'Montserrat-M',
        //                   fontSize: 16,
        //                 ),
        //               ),
        //               Text(
        //                 '${widget.relationship}',
        //                 //style:TextStyle(
        //         fontFamily: 'Montserrat-M',
        //                   fontSize: 16,
        //                 ),
        //               )
        //             ],
        //           ),
        //     SizedBox(
        //       height: 5,
        //     ),
        //     widget.birthay == null
        //         ? Shimmer.fromColors(
        //             child: Container(
        //               width: 62,
        //               height: 17,
        //             ),
        //             baseColor: AppColor.paleGreyFour,
        //             highlightColor: AppColor.whitetwo,
        //           )
        //         : Text(
        //             DateFormat.yMd("vi_VN").format(
        //                   widget.birthay,
        //                 ) ??
        //                 "Chưa cập nhật ngày sinh",
        //             style:TextStyle(
        //              fontFamily: 'Montserrat-M',
        //               fontSize: 16,
        //             ),
        //           ),
        //     SizedBox(
        //       height: 5,
        //     ),
        //     widget.birthay == null
        //         ? Shimmer.fromColors(
        //             child: Container(
        //               width: 62,
        //               height: 17,
        //             ),
        //             baseColor: AppColor.paleGreyFour,
        //             highlightColor: AppColor.whitetwo,
        //           )
        //         : _email(),
        //     SizedBox(
        //       height: 5,
        //     ),
        //     widget.birthay == null
        //         ? Shimmer.fromColors(
        //             child: Container(
        //               width: 62,
        //               height: 17,
        //             ),
        //             baseColor: AppColor.paleGreyFour,
        //             highlightColor: AppColor.whitetwo,
        //           )
        //         : Row(
        //             children: [
        //               Text(
        //                 'Mã hồ sơ: ',
        //                 style:TextStyle(
        //                 fontFamily: 'Montserrat-M',
        //                   fontSize: 16,
        //                 ),
        //               ),
        //               Text(
        //                 '${widget.idfile}',
        //                 style:TextStyle(
        //                fontFamily: 'Montserrat-M',
        //                   fontSize: 16,
        //                 ),
        //               ),
        //             ],
        //           ),
        //   ],
        // ),

        );
  }

  _email() {
    if (widget?.contactModel?.email == null) {
      return Text(
        'Chưa cập nhật email',
        style: TextStyle(
            fontFamily: 'Montserrat-M', fontSize: 14, color: AppColor.warmGrey),
      );
    } else {
      return Text(
        widget?.contactModel?.email,
        style: TextStyle(
            fontFamily: 'Montserrat-M', fontSize: 14, color: AppColor.warmGrey),
      );
    }
  }
}
