import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/staff_model.dart';
import 'package:suns_med/src/Widgets/rating.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/staff/dto/staff_detail_model.dart';
import 'package:suns_med/src/order/session_order_bloc.dart';

class DetailDoctorWidget extends StatefulWidget {
  final String doctorId;
  final Function onTap;
  DetailDoctorWidget({Key key, this.doctorId, this.onTap}) : super(key: key);

  @override
  _DetailDoctorWidgetState createState() => _DetailDoctorWidgetState();
}

class _DetailDoctorWidgetState extends State<DetailDoctorWidget> {
  final bloc = OrderBloc();

  @override
  void initState() {
    bloc.dispatch(EventLoadDetailDoctor(doctorId: widget?.doctorId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderEvent, OrderState, OrderBloc>(
        bloc: bloc,
        builder: (state) {
          if (state?.staff == null)
            return Center(
              child: Text(
                'Chưa có thông tin',
                style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    color: Colors.white,
                    fontSize: 16),
              ),
            );
          else
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppColor.ocenBlue,
                          borderRadius: BorderRadius.circular(8)),
                      height: MediaQuery.of(context).size.width * 0.35,
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 26),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: (state?.staff?.image == null)
                                ? Image.asset(
                                    "assets/images/avatar2.png",
                                    height: 78,
                                    width: 78,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    "${state?.staff?.image}",
                                    height: 78,
                                    width: 78,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    (state?.staff?.name == null)
                                        ? "Bác sĩ"
                                        : state?.staff?.name,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        color: Colors.white,
                                        fontSize: 16),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    (state?.staff?.branchName == null)
                                        ? "Chi nhánh"
                                        : state?.staff?.branchName,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        color: AppColor.lightGray,
                                        fontSize: 12),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  (state?.staff?.specializeName == null)
                                      ? "Chuyên khoa"
                                      : state?.staff?.specializeName,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-M',
                                      color: AppColor.lightGray,
                                      fontSize: 14),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                StarRating(
                                  rating: state?.staff?.rating,
                                  color: Colors.amber,
                                  emptyColor: Colors.grey,
                                  enable: false,
                                  starCount: 5,
                                  size: 8.5,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      padding: EdgeInsets.all(18),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).doctorInfor,
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 14,
                                color: AppColor.warmGrey),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Text(
                            (state?.staff?.description == null)
                                ? AppLocalizations.of(context).noInfor
                                : state?.staff?.description,
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 14,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: widget?.onTap,
                      child: Container(
                        height: 40,
                        width: 130,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: AppColor.lightGray,
                            borderRadius: BorderRadius.circular(45)),
                        child: Text(AppLocalizations.of(context).close),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            );
        });
  }
}
// detailDoctorWidget(
//     StaffDetailModel doctor, Function onTap, BuildContext context)
// // DetailDoctorWidget(
// //     {Key key, this.rating, this.name, this.branch, this.khoa, this.content})
// //     : super(key: key);

// {
//   return SingleChildScrollView(

//   );
// }
