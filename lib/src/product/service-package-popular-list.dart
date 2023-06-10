import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/session_detail_hospital_bloc.dart';
import 'package:suns_med/src/Widgets/products.dart';
import 'package:suns_med/src/home/session_home_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'detailproduct_screen.dart';

class ServicePackagePopularList extends StatefulWidget {
  @override
  _ServicePackagePopularListState createState() =>
      _ServicePackagePopularListState();
}

class _ServicePackagePopularListState extends State<ServicePackagePopularList> {
  final sessionBloc = SessionBloc();
  final homeBloc = HomeBloc();
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    homeBloc.dispatch(EventLoadAllPopularService());
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        homeBloc.dispatch(
          EventLoadMorePopularService(),
        );
      }
    });
    super.initState();
  }

  Future<Null> _refreshHome() async {
    homeBloc.dispatch(EventLoadAllPopularService());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshHome,
        child: BlocProvider<HomeEvent, HomeState, HomeBloc>(
          bloc: homeBloc,
          builder: (state) {
            var servicePackages = state.popularServicePackagePaging?.data;
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
                              title: AppLocalizations.of(context)
                                  .featuredExamination,
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
                                                companyType: CompanyType.Clinic,
                                                serviceId:
                                                    servicePackagePopular,
                                              ),
                                            ),
                                          );
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
