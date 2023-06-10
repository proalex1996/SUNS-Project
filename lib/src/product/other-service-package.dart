import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/session_detail_hospital_bloc.dart';
import 'package:suns_med/src/Widgets/products.dart';
import 'package:suns_med/src/product/session_service_package_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'detailproduct_screen.dart';

class OtherServicePackage extends StatefulWidget {
  @override
  _OtherServicePackageState createState() => _OtherServicePackageState();
}

class _OtherServicePackageState extends State<OtherServicePackage> {
  final servicePackageBloc = ServicePackageBloc();
  final sessionBloc = SessionBloc();
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    servicePackageBloc.dispatch(EventLoadOtherServicePackages());
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        servicePackageBloc.dispatch(
          EventLoadMoreOtherServicePackages(),
        );
      }
    });
    super.initState();
  }

  Future<Null> _refreshHome() async {
    servicePackageBloc.dispatch(EventLoadOtherServicePackages());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.deepBlue,
        centerTitle: true,
        title: Text(
          'Danh sách dịch vụ khác',
          style: TextStyle(
              fontFamily: 'Montserrat-M', fontSize: 18, color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshHome,
        child: BlocProvider<ServicePackageEvent, ServicePackageState,
            ServicePackageBloc>(
          bloc: servicePackageBloc,
          builder: (state) {
            var servicePackages = state.servicePackagePaging?.data;
            return servicePackages == null || servicePackages.isEmpty
                ? Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.3),
                    child: Center(
                      child: Text(AppLocalizations.of(context).notData),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: servicePackages?.length ?? 0,
                    itemBuilder: (context, index) {
                      var servicePackagePopular = servicePackages[index];
                      return ProductItem(
                          isButton: false,
                          genderN: servicePackagePopular?.gender,
                          fromAge: servicePackagePopular?.fromAge,
                          toAge: servicePackagePopular?.toAge,
                          description: servicePackagePopular?.description,
                          exam: servicePackagePopular?.exam,
                          title: servicePackagePopular?.name,
                          image: servicePackagePopular?.image,
                          price: servicePackagePopular?.price?.toDouble(),
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailProductScreen(
                                  companyModel: sessionBloc.state.doctorCheck,
                                  imgService: servicePackagePopular?.image,
                                  companyType: CompanyType.Clinic,
                                  serviceId: servicePackagePopular,
                                ),
                              ),
                            );
                          },
                          test: servicePackagePopular?.test);
                    },
                  );
          },
        ),
      ),
    );
  }
}
