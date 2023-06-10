import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/session_detail_hospital_bloc.dart';
import 'package:suns_med/src/Widgets/products.dart';
import 'package:suns_med/src/home/filter/fillter_model.dart';
import 'package:suns_med/src/Widgets/filter_item.dart';
import 'package:suns_med/src/home/search_all_screen.dart';
import 'package:suns_med/src/home/session_department_bloc.dart';
import 'package:suns_med/src/home/session_home_bloc.dart';
import 'package:suns_med/src/news/news_screen.dart';
import 'package:suns_med/src/news/search_news/detailnews_screen.dart';
import 'package:suns_med/src/product/detailproduct_screen.dart';
import 'package:suns_med/src/product/service-package-popular-list.dart';
import 'package:suns_med/src/product/session_service_package_bloc.dart';
import 'package:suns_med/src/Widgets/slide_dots.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/appointment_service_proxy.dart';
import 'package:suns_med/src/appointment/session_appointment_bloc.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/src/home/test_information.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/service_package_company_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/news/dto/postnews_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/Widgets/Bottombar/navigator_bar.dart';
import 'package:suns_med/src/product/support_chat_admin.dart';
import 'package:suns_med/src/product/home-exam-package-list.dart';
import 'package:suns_med/src/medicine/medicine.dart';
import 'package:suns_med/src/product/service-package-list.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:suns_med/common/dimension.dart';
import 'package:suns_med/src/Widgets/splash_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // int _index = 0;
  final homeBloc = HomeBloc();
  final sessionBloc = SessionBloc();
  final servicePackageBloc = ServicePackageBloc();
  // ProvinceModel _province;
  var name;

  final Geolocator _geolocator = Geolocator();

  final departmentBloc = DepartmentBloc();
  final appointmentBloc = AppointmentBloc();
  final detailItemBloc = DetailItemBloc();
  AppointmentFilterQuery _appointmentFilterQuery = AppointmentFilterQuery();

  int currentPage = 0;
  int _currentPage = 0;
  int _currentPromotionPage = 0;
  bool appointmentAvaiable = true;
  final PageController _pageController = PageController(initialPage: 3);
  final PageController _pageHighlightsController =
      PageController(initialPage: 0);
  final PageController _pagePromotionController =
      PageController(initialPage: 0);

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  _onPageHighlightsChanged(int index) {
    setState(() {
      currentPage = index;
    });
  }

  _onPagePromotionChanged(int index) {
    setState(() {
      _currentPromotionPage = index;
    });
  }

  // void locationPermission() async {
  //   final PermissionStatus permission = await _getLocationPermission();
  //   if (permission == PermissionStatus.granted) {
  //     final position = await Geolocator().getCurrentPosition(
  //         locationPermissionLevel: GeolocationPermission.locationAlways,
  //         desiredAccuracy: LocationAccuracy.medium);

  //     List<Placemark> newPlace = await _geolocator.placemarkFromCoordinates(
  //         position.latitude, position.longitude,
  //         localeIdentifier: "vi_VN");

  //     if (newPlace != null && newPlace.isNotEmpty) {
  //       setState(() {
  //         Placemark placeMark = newPlace[0];
  //         name = placeMark.administrativeArea;
  //       });
  //     }
  //   }
  // }

  // Future<PermissionStatus> _getLocationPermission() async {
  //   final PermissionStatus permission = await LocationPermissions()
  //       .checkPermissionStatus(level: LocationPermissionLevel.location);

  //   if (permission != PermissionStatus.granted) {
  //     final PermissionStatus permissionStatus = await LocationPermissions()
  //         .requestPermissions(
  //             permissionLevel: LocationPermissionLevel.location);

  //     return permissionStatus;
  //   } else {
  //     return permission;
  //   }
  // }

  @override
  void initState() {
    if (departmentBloc.state.bannerNew == null) {
      departmentBloc.dispatch(LoadDepartmentEvent());
      homeBloc.dispatch(EventLoadPopularServicePackage());
    }

    _getDetail();
    // if (appointmentBloc.state.pagingAppointment[1]?.data != null ||
    //     appointmentBloc.state.pagingAppointment[1].data.isNotEmpty) {
    //   appointmentBloc.dispatch(LoadDetailAppointmentvent(
    //       id: appointmentBloc.state.pagingAppointment[1].data.last.id));
    // }
    homeBloc.dispatch(EventLoadPromotionPost());
    // locationPermission();
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients)
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Future _getDetail() async {
    setState(() {
      _appointmentFilterQuery.appointmentStatuses = [1];
    });
    appointmentBloc.dispatch(
        EventLoadAppointment(filterQuery: _appointmentFilterQuery, type: 1));
  }
  // Future getResult() async {
  //   Future.wait({_getDetail()}).then((value) {
  //     if (appointmentBloc.state.pagingAppointment[1] != null) {
  //       _getDetailAppointment();
  //     } else
  //       setState(() {
  //         appointmentAvaiable = false;
  //       });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var useMobileLayout = shortestSide < 600;
    final fillterList = [
      Fillter(
          image: 'assets/imgclinic/ic_tuvan.png',
          title: AppLocalizations.of(context).advise,
          color: AppColor.azure,
          function: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SupportChatAdmin()),
            );
          }),
      Fillter(
          image: 'assets/imgclinic/ic_kham.png',
          title: AppLocalizations.of(context).examinationHome,
          color: AppColor.brightOrange,
          function: () {
            var appointment = appointmentBloc.state.pagingAppointment[1].data;
            appointment.isEmpty || appointment == null
                ? _noAppointmentDialog(context, useMobileLayout)
                : _testInfor(
                    context,
                    appointment.first.id,
                    appointment.first.staffName,
                    appointmentBloc.state?.detailAppointment?.branchName ??
                        AppLocalizations.of(context).center,
                    appointmentBloc.state?.detailAppointment?.staffSpecialize ??
                        AppLocalizations.of(context).specialist,
                    useMobileLayout,
                    appointment?.first?.staffUserId);
          }),
      Fillter(
          image: 'assets/imgclinic/ic_multiple.png',
          title: AppLocalizations.of(context).service,
          color: AppColor.bluishGreen,
          function: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ServicePackageList()),
            );
          }),
      Fillter(
          image: 'assets/imgclinic/ic_medicine.png',
          title: AppLocalizations.of(context).medicine,
          color: AppColor.mustard,
          function: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Medicine()),
            );
          }),
    ];

    return Scaffold(
        backgroundColor: AppColor.white,
        appBar: const TopAppBar(),
        body: Stack(
          children: [
            Container(
              alignment: Alignment.centerRight,
              child: Image.asset(
                'assets/images/halff_moon.png',
                width: MediaQuery.of(context).size.width / 2,
                fit: BoxFit.cover,
              ),
            ),
            RefreshIndicator(
              onRefresh: _refreshHome,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        BlocProvider<HomeEvent, HomeState, HomeBloc>(
                          bloc: homeBloc,
                          builder: (state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: useMobileLayout
                                      ? 235
                                      : MediaQuery.of(context).size.height *
                                          0.3,
                                  child: Stack(
                                    children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        width: double.infinity,
                                        // height: useMobileLayout
                                        //     ? MediaQuery.of(context).size.height *
                                        //         0.25
                                        //     : MediaQuery.of(context).size.height *
                                        //         0.20,
                                        height: useMobileLayout
                                            ? 190
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.25,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/purple-appbar.png'),
                                              fit: BoxFit.cover),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            // SizedBox(
                                            //   height: 10,
                                            // ),
                                            // Wrap(
                                            //   alignment: WrapAlignment.center,
                                            //   // mainAxisAlignment: MainAxisAlignment.center,
                                            //   children: [
                                            //     Text(
                                            //       "Chào mừng",
                                            //       style:TextStyle(
                                            //   fontFamily: 'Montserrat-M',
                                            //           // fontWeight: FontWeight.bold,
                                            //           // fontStyle: FontStyle.italic,
                                            //           fontSize: useMobileLayout ? 16 : 28,
                                            //           color: Color(0xff00546D)),
                                            //     ),
                                            //     Text(
                                            //       sessionBloc.state.user != null
                                            //           ? " ${sessionBloc.state.user?.fullName}"
                                            //           : "Loading...",
                                            //       style:TextStyle(
                                            //  fontFamily: 'Montserrat-M',
                                            //           fontWeight: FontWeight.bold,
                                            //           fontStyle: FontStyle.italic,
                                            //           fontSize: useMobileLayout ? 16 : 28,
                                            //           color: Color(0xff00546D)),
                                            //     ),
                                            //     Text(
                                            //       " đến với Gcare!",
                                            //       style:TextStyle(
                                            // fontFamily: 'Montserrat-M',
                                            //           // fontWeight: FontWeight.bold,
                                            //           // fontStyle: FontStyle.italic,
                                            //           fontSize: useMobileLayout ? 16 : 28,
                                            //           color: Color(0xff00546D)),
                                            //     ),
                                            //   ],
                                            // ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                bottom: 45,
                                              ),
                                              width: double.infinity,
                                              child: Wrap(
                                                  alignment:
                                                      WrapAlignment.spaceAround,
                                                  children: List.generate(
                                                      fillterList.length,
                                                      (index) {
                                                    return FilterITem(
                                                      title: fillterList[index]
                                                          .title,
                                                      image: fillterList[index]
                                                          .image,
                                                      function:
                                                          fillterList[index]
                                                              .function,
                                                      color: fillterList[index]
                                                          .color,
                                                    );
                                                  })),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        left: 10,
                                        right: 10,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        SearchAllScreen()));
                                          },
                                          child: Container(
                                              child: Card(
                                            shadowColor: Colors.white,
                                            elevation: 14.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 13.0),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .search,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat-M',
                                                          fontSize:
                                                              useMobileLayout
                                                                  ? 16
                                                                  : 28,
                                                          color: Colors.grey),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(3),
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Color(
                                                              0xFFF2F6FE)),
                                                      child: Icon(
                                                        Icons.search,
                                                        color: AppColor.purple,
                                                        size: useMobileLayout
                                                            ? 30
                                                            : 45,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20, top: 15),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .yourAppointment,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        fontSize: useMobileLayout ? 16 : 28,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                _buildAppointment(useMobileLayout, context),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 21, top: 21),
                                  // width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .featuredExamination,
                                          style: TextStyle(
                                              fontFamily: 'Montserrat-M',
                                              fontSize:
                                                  useMobileLayout ? 16 : 28,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ServicePackagePopularList()));
                                        },
                                        child: Container(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .viewAll,
                                            style: TextStyle(
                                              fontFamily: 'Montserrat-M',
                                              fontSize:
                                                  useMobileLayout ? 16 : 28,
                                              color: AppColor.deepBlue,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                buildHightlightPackage(
                                    state.servicePackageOfCompany,
                                    context,
                                    useMobileLayout),
                                SizedBox(
                                  height: 15,
                                ),
                                buildDotHighlight(
                                    state.servicePackageOfCompany),
                                // _getDepartment(),
                                SizedBox(
                                  height: 30,
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10, left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context).youKnow,
                                        style: TextStyle(
                                            fontFamily: 'Montserrat-M',
                                            fontSize: useMobileLayout ? 16 : 28,
                                            color: AppColor.darkPurple,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (ctx) => BottomBar(
                                                        index: 3,
                                                      )),
                                              (Route<dynamic> route) => false);
                                        },
                                        child: Container(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .viewAll,
                                            style: TextStyle(
                                              fontFamily: 'Montserrat-M',
                                              fontSize:
                                                  useMobileLayout ? 16 : 28,
                                              color: AppColor.deepBlue,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                buildDidYouKnow(
                                    state.listPost, context, useMobileLayout),
                                SizedBox(
                                  height: 20,
                                ),
                                _getBanner(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10, left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context).promotion,
                                        style: TextStyle(
                                            fontFamily: 'Montserrat-M',
                                            fontSize: useMobileLayout ? 16 : 28,
                                            color: AppColor.darkPurple,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (ctx) => BottomBar(
                                                        index: 3,
                                                      )),
                                              (Route<dynamic> route) => false);
                                        },
                                        child: Container(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .viewAll,
                                            style: TextStyle(
                                              fontFamily: 'Montserrat-M',
                                              fontSize:
                                                  useMobileLayout ? 16 : 28,
                                              color: AppColor.deepBlue,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                buildPromotion(state.listPromotionPost, context,
                                    useMobileLayout),
                                // SizedBox(
                                //   height: 15,
                                // ),
                                // buildDot(state.listPromotionPost.length,
                                //     _currentPromotionPage)
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Container buildPromotion(List<PostNewsModel> listPromotionPost,
      BuildContext context, bool useMobileLayout) {
    return Container(
      height: useMobileLayout ? 390 : height(context) * 0.47,
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: (listPromotionPost?.length == 0)
          ? Center(
              child: Text(
                AppLocalizations.of(context).notData,
                style: TextStyle(fontSize: useMobileLayout ? 16 : 22),
              ),
            )
          : PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: _pagePromotionController,
              onPageChanged: _onPagePromotionChanged,
              itemCount: listPromotionPost?.length ?? 0,
              itemBuilder: (ctx, i) {
                var promotion = listPromotionPost[i];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailNewsScreen(
                            news: promotion,
                            listNews: listPromotionPost,
                          ),
                        ));
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 20, right: 20, bottom: 20, top: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 15,
                            color: Colors.black12,
                            offset: Offset(0, 0))
                      ],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: (promotion?.image == null)
                                ? Image.asset(
                                    'assets/images/promotion-image.png',
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    promotion.image,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                '${promotion?.name ?? ''}',

                                // overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.darkPurple,
                                    height: 2.2),
                              )),
                        )
                      ],
                    ),
                  ),
                );
              }),
    );
  }

  buildDidYouKnow(List<PostNewsModel> listPost, BuildContext context,
      bool useMobileLayout) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                blurRadius: 15, color: Colors.black12, offset: Offset(0, 0))
          ]),
      padding: const EdgeInsets.only(left: 15, right: 15),
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        children: List.generate(
          listPost?.length ?? 0,
          (index) {
            var post = listPost[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailNewsScreen(
                      news: post,
                      listNews: listPost,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: useMobileLayout ? 100 : 200,
                        height: useMobileLayout ? 100 : 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: post?.image == null
                            ? Image.asset(
                                'assets/images/logo.png',
                                width: useMobileLayout ? 100 : 200,
                                height: useMobileLayout ? 100 : 200,
                              )
                            : Image.network(post?.image),
                      ),
                      SizedBox(
                        width: useMobileLayout ? 15 : 25,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Container(
                            //   padding: useMobileLayout
                            //       ? const EdgeInsets.all(5)
                            //       : const EdgeInsets.all(10),
                            //   decoration: BoxDecoration(
                            //       color: Colors.grey[200],
                            //       borderRadius: BorderRadius.circular(25)),
                            //   child: Text(
                            //     post?.categoryName,
                            //     style:TextStyle(
                            //     fontFamily: 'Montserrat-M',
                            //         color: Colors.grey,
                            //         fontSize: useMobileLayout ? 16 : 28),
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 5,
                            // ),
                            Container(
                              padding: EdgeInsets.only(
                                bottom: 10,
                              ),
                              child: Text(
                                post?.name,
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontWeight: FontWeight.bold,
                                    fontSize: useMobileLayout ? 16 : 28),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.favorite_border_outlined,
                                  color: AppColor.deepBlue,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('${post.totalLike}')
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Divider()
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Center buildDotHighlight(
      List<ServicePackageOfCompanyModel> servicePackageOfCompany) {
    var service = servicePackageOfCompany?.length ?? 0;
    return Center(
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (int i = 0; i < service; i++)
              if (i == currentPage)
                SlideDots(true, 20, 20, AppColor.purple)
              else
                SlideDots(false, 17, 17, AppColor.greyColor)
          ],
        ),
      ),
    );
  }

  buildHightlightPackage(
      List<ServicePackageOfCompanyModel> servicePackageOfCompany,
      BuildContext context,
      bool useMobileLayout) {
    return (servicePackageOfCompany?.length == 0)
        ? Container(
            height: 20,
            child: Center(
                child: Text(
              AppLocalizations.of(context).notData,
              style: TextStyle(fontSize: useMobileLayout ? 16 : 22),
            )),
          )
        : Container(
            height: useMobileLayout ? 290 : height(context) * 0.4,
            // padding: EdgeInsets.symmetric(vertical: 20),
            child: PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: _pageHighlightsController,
                onPageChanged: _onPageHighlightsChanged,
                itemCount: servicePackageOfCompany?.length ?? 0,
                itemBuilder: (ctx, i) {
                  var servicePackagePopular = servicePackageOfCompany[i];
                  return ProductItem(
                      isButton: false,
                      genderN: servicePackagePopular?.gender,
                      fromAge: servicePackagePopular?.fromAge,
                      toAge: servicePackagePopular?.toAge,
                      description: servicePackagePopular?.description,
                      exam: servicePackagePopular?.exam,
                      title: servicePackagePopular?.name,
                      image: servicePackagePopular?.image,
                      price: servicePackagePopular?.price?.toDouble() ?? 0,
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailProductScreen(
                              imgService: servicePackagePopular?.image,
                              companyModel: sessionBloc.state.doctorCheck,
                              companyType: CompanyType.Clinic,
                              serviceId: servicePackagePopular,
                              // sessionBloc
                              //     .state.doctorCheck.address,
                            ),
                          ),
                        );
                      },
                      test: servicePackagePopular?.test);
                }),
          );
  }

  _buildAppointment(bool useMobileLayout, BuildContext context) {
    return BlocProvider<AppointmentEvent, AppointmentState, AppointmentBloc>(
        bloc: appointmentBloc,
        builder: (output) {
          var appointment = appointmentBloc.state.pagingAppointment[1]?.data;
          if (output.detailAppointment == null) {
            if (appointment == null || appointment.isEmpty) {
              print('');
            } else
              appointmentBloc.dispatch(
                  LoadDetailAppointmentvent(id: appointment.first.id));
          }
          return appointment == null || appointment.isEmpty
              ? Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).notAppointment,
                      style: TextStyle(fontSize: useMobileLayout ? 16 : 22),
                    ),
                  ),
                )
              //Đang hiển thị lịch hẹn mới nhất của trạng thái Đã xác nhận
              : GestureDetector(
                  onTap: () async {
                    _testInfor(
                        context,
                        appointment.first.id,
                        appointment.first.staffName,
                        output?.detailAppointment?.branchName ??
                            AppLocalizations.of(context).center,
                        output?.detailAppointment?.staffSpecialize ??
                            AppLocalizations.of(context).specialist,
                        useMobileLayout,
                        appointment?.first?.staffUserId);
                  },
                  child: Container(
                    //padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Column(
                      children: [
                        Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 15),
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color(0xFF438BA7),
                                Color(0xFF99438BA7)
                              ]),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 90,
                                  width: 110,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: (output?.detailAppointment
                                                ?.staffImage !=
                                            null)
                                        ? Image.network(
                                            output.detailAppointment.staffImage,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/images/doctor-image.png',
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            appointment.first.staffName ?? '',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat-M',
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          Container(
                                            width: useMobileLayout ? 180 : 260,
                                            padding: const EdgeInsets.only(
                                                top: 10, bottom: 10, right: 20),
                                            child: Text(
                                                output?.detailAppointment
                                                        ?.branchName ??
                                                    AppLocalizations.of(context)
                                                        .center,
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat-M',
                                                    fontSize: 14,
                                                    color: Colors.white70)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5, right: 10),
                                            child: Text(
                                                output.detailAppointment
                                                        ?.staffSpecialize ??
                                                    AppLocalizations.of(context)
                                                        .specialist,
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat-M',
                                                    fontSize: 14,
                                                    color: Colors.white70,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                          Row(
                                            children: [
                                              Wrap(
                                                children:
                                                    List.generate(5, (index) {
                                                  return Icon(
                                                    Icons.star_rate_rounded,
                                                    color: Colors.yellow,
                                                    size: 15,
                                                  );
                                                }),
                                              )
                                            ],
                                          ),
                                          Text(
                                            DateFormat('kk:mm - dd/MM ').format(
                                                appointment.first
                                                        ?.appointmentTime ??
                                                    ''),
                                            style: TextStyle(
                                                fontFamily: 'Montserrat-M',
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ]),
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                );
        });
  }

  Future<void> _testInfor(BuildContext context, String id, String doctorName,
      String department, String specialist, bool useMobile, int staffId) async {
    // return showGeneralDialog(
    //   barrierLabel: "Label",
    //   barrierDismissible: true,
    //   barrierColor: Colors.black.withOpacity(0.5),
    //   transitionDuration: Duration(milliseconds: 350),
    //   context: context,
    //   pageBuilder: (context, anim1, anim2) {
    //     return Container(
    //       // padding: EdgeInsets.symmetric(vertical: 20),
    //       child: ClipRRect(
    //         borderRadius: BorderRadius.circular(15),
    //         child: TestInformation(
    //           id: id,
    //           doctorName: doctorName,
    //           department: department,
    //           branch: branch,
    //         ),
    //       ),
    //       margin: EdgeInsets.only(
    //           bottom: MediaQuery.of(context).size.height * 0.33,
    //           left: 25,
    //           right: 25,
    //           top: MediaQuery.of(context).size.height * 0.3),
    //       decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadius.circular(30),
    //       ),
    //     );
    //   },
    //   transitionBuilder: (context, anim1, anim2, child) {
    //     return SlideTransition(
    //       position:
    //           Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
    //       child: child,
    //     );
    //   },
    // );
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              insetAnimationDuration: Duration(milliseconds: 900),
              insetAnimationCurve: Curves.easeInOut,
              insetPadding: EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                height:
                    useMobile ? 320 : MediaQuery.of(context).size.height * 0.37,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: TestInformation(
                    id: id,
                    useMobileLayout: useMobile,
                    doctorName: doctorName,
                    department: department,
                    specialist: specialist,
                    staffId: staffId,
                  ),
                ),
              ));
        });
  }

  Future<void> _noAppointmentDialog(
      BuildContext context, bool useMobile) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              insetAnimationDuration: Duration(milliseconds: 900),
              insetAnimationCurve: Curves.easeInOut,
              insetPadding: EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                height:
                    useMobile ? 180 : MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ListTile(
                      title: Center(
                          child: Text(
                              AppLocalizations.of(context).examinationInfo,
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: useMobile ? 17 : 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.purple))),
                      trailing: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColor.ocenBlue)),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.clear_outlined,
                              size: 22,
                            ),
                          )),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Bạn chưa có lịch hẹn khám',
                        style: TextStyle(
                          fontSize: useMobile ? 15 : 26,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ServicePackageList()),
                        );
                      },
                      child: Container(
                        // alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.only(right: 5, left: 5),
                        margin: EdgeInsets.only(bottom: 20, top: 20),
                        height: useMobile ? 36 : 51,
                        width: useMobile ? 220 : 360,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColor.purple,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/imgclinic/ic_calendar.png',
                              width: useMobile ? 15.2 : 30,
                              height: useMobile ? 15.2 : 30,
                            ),
                            SizedBox(
                              width: 6.8,
                            ),
                            Text(
                              AppLocalizations.of(context).book,
                              style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: useMobile ? 15 : 26,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ));
        });
  }

  _getBanner() {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var useMobileLayout = shortestSide < 600;
    return BlocProvider<DepartmentEvent, DepartmentState, DepartmentBloc>(
      bloc: departmentBloc,
      builder: (state) {
        var checkState = state.bannerNew == null;
        return checkState
            ? Container()
            : Container(
                height: useMobileLayout ? 160 : 280,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  scrollDirection: Axis.horizontal,
                  itemCount: state?.bannerNew?.length ?? 0,
                  itemBuilder: (ctx, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            state?.bannerNew[index].image,
                            fit: BoxFit.cover,
                          )),
                    );
                  },
                ),
              );
      },
    );
  }

  Future<Null> _refreshHome() async {
    departmentBloc.dispatch(LoadDepartmentEvent());
    homeBloc.dispatch(EventLoadPopularServicePackage());
    _getDetail();
  }

  // _buildLocationText() {
  //   var shortestSide = MediaQuery.of(context).size.shortestSide;
  //   var useMobileLayout = shortestSide < 600;
  //   // return BlocProvider<LocationEvent, LocationState, LocationBloc>(
  //   //   bloc: locationBloc,
  //   //   builder: (state) {
  //   // var locationName = state.provinceSelected?.name ?? "Your City";
  //   return Text(
  //     name == "Thành Phố Hồ Chí Minh"
  //         ? name = "TP.HCM"
  //         : name != null
  //             ? "$name"
  //             : "TP.HCM",
  //     overflow: TextOverflow.ellipsis,
  //     style:
  //        TextStyle(
  //           fontFamily: 'Montserrat-M',color: Colors.black, fontSize: useMobileLayout ? 16 : 28),
  //   );
  //   //   },
  //   // );
  // }
}
