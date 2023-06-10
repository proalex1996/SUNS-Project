import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/session_detail_hospital_bloc.dart';
import 'package:suns_med/src/Widgets/products.dart';
import 'package:suns_med/src/product/session_service_package_bloc.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'detailproduct_screen.dart';

class HomeExamPackage extends StatefulWidget {
  @override
  _HomeExamPackageState createState() => _HomeExamPackageState();
}

class _HomeExamPackageState extends State<HomeExamPackage> {
  final servicePackageBloc = ServicePackageBloc();
  final sessionBloc = SessionBloc();
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    servicePackageBloc.dispatch(EventLoadHomeExamPackages());
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        servicePackageBloc.dispatch(
          EventLoadMoreHomeExamPackages(),
        );
      }
    });
    super.initState();
  }

  Future<Null> _refreshHome() async {
    servicePackageBloc.dispatch(EventLoadHomeExamPackages());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: AppColor.deepBlue,
      //   centerTitle: true,
      //   title: Text(
      //     'Danh sách gói khám tại nhà',
      //     style:TextStyle(
      //         fontFamily: 'Montserrat-M',fontSize: 18, color: Colors.white),
      //   ),
      // ),
      appBar: const TopAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshHome,
        child: Column(
          children: [
            CustomAppBar(
              title: AppLocalizations.of(context).homePackage,
              titleSize: 18,
            ),
            BlocProvider<ServicePackageEvent, ServicePackageState,
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
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
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
                                      imgService: servicePackagePopular?.image,
                                      companyModel:
                                          sessionBloc.state.doctorCheck,
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
          ],
        ),
      ),
    );
  }
}
