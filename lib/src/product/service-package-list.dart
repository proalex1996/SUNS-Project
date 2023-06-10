import 'package:age/age.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/session_detail_hospital_bloc.dart';
import 'package:suns_med/src/Widgets/products.dart';
import 'package:suns_med/src/product/session_service_package_bloc.dart';
import 'package:suns_med/src/home/session_home_bloc.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/contact_model.dart';
import 'detailproduct_screen.dart';

class ServicePackageList extends StatefulWidget {
  final ContactModel contact;
  ServicePackageList({
    this.contact,
  });
  @override
  _ServicePackageListState createState() => _ServicePackageListState();
}

class _ServicePackageListState extends State<ServicePackageList> {
  final servicePackageBloc = ServicePackageBloc();
  final sessionBloc = SessionBloc();
  ScrollController _scrollController = ScrollController();
  AgeDuration age;
  @override
  void initState() {
    servicePackageBloc.dispatch(EventLoadServicePackage());
    super.initState();
    if (widget?.contact != null) {
      age = Age.dateDifference(
          fromDate: widget?.contact?.birthDay,
          toDate: DateTime.now(),
          includeToDate: false);
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('max Scroll');
        servicePackageBloc.dispatch(
          EventLoadMoreService(),
        );
      }
    });
  }

  Future<Null> _refreshHome() async {
    servicePackageBloc.dispatch(EventLoadServicePackage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshHome,
        child: BlocProvider<ServicePackageEvent, ServicePackageState,
            ServicePackageBloc>(
          bloc: servicePackageBloc,
          builder: (state) {
            var servicePackages = state.servicePackagePaging?.data;
            return servicePackages == null || servicePackages.isEmpty
                ? Column(children: [
                    Container(
                      height: 85,
                      child: CustomAppBar(
                        title: AppLocalizations.of(context).allPackage,
                        titleSize: 20,
                        isOrangeAppBar: true,
                        isTopPadding: true,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.3),
                      child: Center(
                        child: Text(AppLocalizations.of(context).notData),
                      ),
                    ),
                  ])
                : SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CustomAppBar(
                              title: AppLocalizations.of(context).allPackage,
                              titleSize: 20,
                              isOrangeAppBar: true,
                              isTopPadding: true,
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 90, bottom: 20),
                                child: Wrap(
                                  children: List.generate(
                                      servicePackages?.length ?? 0, (index) {
                                    var servicePackagePopular =
                                        servicePackages[index];
                                    return ProductItem(
                                        isButton: true,
                                        genderN: servicePackagePopular?.gender,
                                        fromAge: servicePackagePopular?.fromAge,
                                        toAge: servicePackagePopular?.toAge,
                                        description:
                                            servicePackagePopular?.description,
                                        exam: servicePackagePopular?.exam,
                                        title: servicePackagePopular?.name,
                                        image: servicePackagePopular?.image,
                                        price: servicePackagePopular?.price
                                            ?.toDouble(),
                                        press: () {
                                          if ((widget?.contact == null) ||
                                              (servicePackagePopular?.gender == widget?.contact?.gender && age.years >= servicePackagePopular?.fromAge && age.years <= servicePackagePopular?.toAge ||
                                                  servicePackagePopular?.gender == widget?.contact?.gender &&
                                                      age.years >=
                                                          servicePackagePopular
                                                              ?.fromAge &&
                                                      servicePackagePopular?.toAge ==
                                                          null ||
                                                  servicePackagePopular?.gender == widget?.contact?.gender &&
                                                      age.years <=
                                                          servicePackagePopular
                                                              ?.toAge &&
                                                      servicePackagePopular?.fromAge ==
                                                          null ||
                                                  servicePackagePopular?.gender == widget?.contact?.gender &&
                                                      servicePackagePopular?.toAge ==
                                                          null &&
                                                      servicePackagePopular?.fromAge ==
                                                          null ||
                                                  servicePackagePopular?.gender == null &&
                                                      servicePackagePopular?.toAge ==
                                                          null &&
                                                      servicePackagePopular?.fromAge ==
                                                          null ||
                                                  servicePackagePopular?.gender == null &&
                                                      age.years >=
                                                          servicePackagePopular
                                                              ?.fromAge &&
                                                      age.years <=
                                                          servicePackagePopular
                                                              ?.toAge ||
                                                  servicePackagePopular?.gender == null &&
                                                      age.years >=
                                                          servicePackagePopular
                                                              ?.fromAge &&
                                                      servicePackagePopular?.toAge ==
                                                          null ||
                                                  servicePackagePopular?.gender == null &&
                                                      age.years <= servicePackagePopular?.toAge &&
                                                      servicePackagePopular?.fromAge == null)) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailProductScreen(
                                                  imgService:
                                                      servicePackagePopular
                                                          ?.image,
                                                  companyModel: sessionBloc
                                                      .state.doctorCheck,
                                                  companyType:
                                                      CompanyType.Clinic,
                                                  serviceId:
                                                      servicePackagePopular,
                                                  contact: widget?.contact,
                                                ),
                                              ),
                                            );
                                          } else {
                                            Flushbar(
                                              margin: EdgeInsets.all(8),
                                              borderRadius: 8,
                                              title:
                                                  AppLocalizations.of(context)
                                                      .notification,
                                              message:
                                                  AppLocalizations.of(context)
                                                      .servicePackageInvalid,
                                              duration: Duration(seconds: 3),
                                            )..show(context);
                                          }
                                        },
                                        test: servicePackagePopular?.test);
                                  }),
                                )),
                          ],
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
