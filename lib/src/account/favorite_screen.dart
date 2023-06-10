import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/detail_hopital_item_screen.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/session_detail_hospital_bloc.dart';
import 'package:suns_med/src/Widgets/hospital_item/hospital_item.dart';
import 'package:suns_med/src/Widgets/location/session_location_bloc.dart';
import 'package:suns_med/src/account/session_account_bloc.dart';

class FavoriteScreen extends StatefulWidget {
  final String provinceId;
  final String type;

  const FavoriteScreen({Key key, this.provinceId, this.type}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final bloc = AccountBloc();
  final locationBloc = LocationBloc();
  // ProvinceModel _province;
  CompanyType companyType;

  @override
  void initState() {
    bloc.dispatch(LoadLikeCompany());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.deepBlue,
        title: Text(
          'Yêu thích',
          style: TextStyle(
              fontFamily: 'Montserrat-M', fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 40,
              padding: const EdgeInsets.only(
                left: 21,
                top: 12,
              ),
              decoration:
                  BoxDecoration(color: AppColor.veryLightPinkFour, boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ]),
              child: Text(
                'Danh sách bác sĩ, phòng khám đã thích',
                style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: 16,
                    color: AppColor.deepBlue,
                    fontWeight: FontWeight.bold),
              ),
            ),
            _getFavorite(),
          ],
        ),
      ),
    );
  }

  _getFavorite() {
    return BlocProvider<AccountEvent, AccountState, AccountBloc>(
      bloc: bloc,
      builder: (output) {
        // var checkLike = output.likeCompany = 0;

        return Container(
          child: Wrap(
            children: List.generate(
              output.likeCompany?.length ?? 0,
              (index) {
                var news = output?.likeCompany[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: HospitalItem(
                    companyId: news?.id,
                    companyType: news?.type == 1
                        ? CompanyType.Doctor
                        : news?.type == 2
                            ? CompanyType.Clinic
                            : CompanyType.Hospital,
                    press: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailHospitalItemScreen(
                          id: news?.id,
                          city: this.widget.provinceId,
                          type: news?.type == 1
                              ? CompanyType.Doctor
                              : news?.type == 2
                                  ? CompanyType.Clinic
                                  : CompanyType.Hospital,
                        ),
                      ),
                    ),
                    provinceId: this.locationBloc.state.provinceSelected.id,
                    address: news?.address,
                    image: news?.image,
                    name: news?.name,
                    specialist: news?.specialized,
                    favorite: news?.totalLike,
                    totalRate: news?.rating?.toDouble(),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
