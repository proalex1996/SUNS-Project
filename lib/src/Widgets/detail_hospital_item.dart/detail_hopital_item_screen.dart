import 'package:flutter/material.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/detail_hospital_item_model.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/bodydetails_screen.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/session_detail_hospital_bloc.dart';

class DetailHospitalItemScreen extends StatefulWidget {
  final CompanyType type;
  final String id;
  final String city;
  final DetailHospitalModel detailDoctorModel;
  const DetailHospitalItemScreen(
      {Key key,
      this.detailDoctorModel,
      @required this.id,
      this.city,
      @required this.type})
      : super(key: key);

  @override
  _DetailHospitalItemScreenState createState() =>
      _DetailHospitalItemScreenState();
}

class _DetailHospitalItemScreenState extends State<DetailHospitalItemScreen> {
  final bloc = DetailItemBloc();

  @override
  void initState() {
    if (this.widget.type == CompanyType.Doctor) {
      bloc.dispatch(LoadDetailDoctorEvent(id: this.widget.id));
    } else if (this.widget.type == CompanyType.Hospital) {
      bloc.dispatch(LoadDetailHospitalEvent(id: this.widget.id));
    } else if (this.widget.type == CompanyType.Clinic) {
      bloc.dispatch(LoadDetailClinicEvent(id: this.widget.id));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.deepBlue,
          centerTitle: true,
          title: Text(
            this.widget.type == CompanyType.Doctor
                ? 'Bác sĩ'
                : this.widget.type == CompanyType.Hospital
                    ? "Bệnh viện"
                    : "Phòng khám",
            style: TextStyle(
                fontFamily: 'Montserrat-M', fontSize: 18, color: Colors.white),
          ),
          actions: <Widget>[
            BlocProvider<DetailItemEvent, DetailItemState, DetailItemBloc>(
                bloc: bloc,
                builder: (state) {
                  return IconButton(
                      icon: state.hasLike == true
                          ? Icon(
                              Icons.favorite,
                              color: Colors.redAccent,
                            )
                          : Icon(Icons.favorite_border),
                      onPressed: () {
                        if (state.hasLike != true) {
                          if (this.widget.type == CompanyType.Doctor) {
                            bloc.dispatch(LikeDoctor(id: this.widget.id));
                          } else if (this.widget.type == CompanyType.Hospital) {
                            bloc.dispatch(LikeHospital(id: this.widget.id));
                          } else if (this.widget.type == CompanyType.Clinic) {
                            bloc.dispatch(LikeClinic(id: this.widget.id));
                          }
                        } else {
                          if (this.widget.type == CompanyType.Doctor) {
                            bloc.dispatch(UnlikeDoctor(id: this.widget.id));
                          } else if (this.widget.type == CompanyType.Hospital) {
                            bloc.dispatch(UnlikeHospital(id: this.widget.id));
                          } else if (this.widget.type == CompanyType.Clinic) {
                            bloc.dispatch(UnlikeClinic(id: this.widget.id));
                          }
                        }
                      });
                })
          ],
        ),
        body: SingleChildScrollView(
          child: BodyDetailsScreen(
            id: widget.id,
            city: widget.city,
            type: this.widget.type,
          ),
        ));
  }
}
