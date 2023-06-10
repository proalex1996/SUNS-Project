import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/doctor_check/dto/doctorcheck_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/service_package_company_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/service_package/dto/detail_service_model.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/session_detail_hospital_bloc.dart';
import 'package:suns_med/src/order/order_screen.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/clinic/dto/clinic_branch_model.dart';
import 'package:html/dom.dart' as dom;
import 'package:expandable/expandable.dart';
import 'session_service_package_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/contact_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/service_package/dto/branch_model.dart';

class DetailProductScreen extends StatefulWidget {
  final ServicePackageOfCompanyModel serviceId;
  final CompanyType companyType;
  final DoctorCheckModel companyModel;
  final String imgService;
  final ContactModel contact;

  DetailProductScreen(
      {Key key,
      this.serviceId,
      this.companyModel,
      this.companyType,
      this.imgService,
      this.contact})
      : super(key: key);
  @override
  _DetailProductScreenState createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  final money = NumberFormat('#,###,000');
  final bloc = ServicePackageBloc();
  final sessionBloc = SessionBloc();
  final date = DateTime.now();
  String _branchId;
  int _index;
  bool isWhyExpand = false,
      isotherCategoryExpand = false,
      isProcessExpand = false,
      isExamExpand = false,
      isTestExpand = false,
      isNOteExpand = false,
      haveBranch = false;
  @override
  void initState() {
    bloc.dispatch(LoadDetailServiceEvent(
        servicePackageId: this.widget.serviceId.id, brandId: ''));
    sessionBloc.dispatch((EventGetUser()));
    bloc.dispatch(EventLoadBranch(id: this.widget.serviceId.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var useMobileLayout = shortestSide < 600;
    return Scaffold(
      appBar: const TopAppBar(),
      body: Container(
        child: BlocProvider<ServicePackageEvent, ServicePackageState,
                ServicePackageBloc>(
            bloc: bloc,
            builder: (state) {
              var data = state?.detailService;
              return data == null
                  ? Container()
                  : SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            Stack(
                              children: <Widget>[
                                CustomAppBar(
                                  title: data?.name ?? '',
                                  titleSize: 20,
                                  hasBackButton: true,
                                  isOrangeAppBar: true,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(top: 95),
                                  child: widget.imgService != null &&
                                          widget.imgService.isNotEmpty
                                      ? Image.network(
                                          widget.imgService,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.27,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.14,
                                          fit: BoxFit.contain,
                                        )
                                      : Image.asset(
                                          'assets/images/goikham2.png',
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.27,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.14,
                                          fit: BoxFit.contain,
                                        ),
                                )
                              ],
                            ),
                            buildInforContainer(useMobileLayout, data),
                            buildPrice(data),
                            Container(
                              padding: EdgeInsets.only(left: 20, top: 20),
                              alignment: Alignment.topLeft,
                              child: Text(
                                AppLocalizations.of(context).executionBranch,
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    color: Colors.grey,
                                    fontSize: 14),
                              ),
                            ),
                            buildBranchList(context),
                            SizedBox(
                              height: 20,
                            ),
                            _buildWhyHeader(
                              context,
                              AppLocalizations.of(context).whyShouldOrder,
                            ),
                            buildVisibilityWidget(
                              isWhyExpand,
                              state,
                              (data?.whyInfos?.length == 0)
                                  ? Container(
                                      height: 50,
                                      child: Center(
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .notData)),
                                    )
                                  : Wrap(
                                      children: List.generate(
                                          data?.whyInfos?.length ?? 0, (index) {
                                        var whyInfos = data?.whyInfos[index];
                                        return Container(
                                          padding:
                                              const EdgeInsets.only(top: 14),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    right: 8),
                                                child: Stack(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .bottomCenter,
                                                  children: <Widget>[
                                                    CircleAvatar(
                                                        backgroundColor:
                                                            Color(0xffdedbf2),
                                                        maxRadius: 30,
                                                        child: whyInfos.image !=
                                                                null
                                                            ? Image.network(
                                                                whyInfos.image,
                                                                width: 25,
                                                                height: 39,
                                                              )
                                                            : SizedBox()),
                                                    whyInfos.isFree == false
                                                        ? Container()
                                                        : Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: 72,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                                color: Colors
                                                                    .orange),
                                                            child: Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .free,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Montserrat-M',
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          )
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    whyInfos.name,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat-M',
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Container(
                                                    width: 222,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    child: Text(
                                                      whyInfos?.description ??
                                                          AppLocalizations.of(
                                                                  context)
                                                              .notData,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat-M',
                                                          fontSize: 15),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            _buildProcessHeader(context,
                                AppLocalizations.of(context).procedures),
                            buildVisibilityWidget(
                              isProcessExpand,
                              state,
                              (data?.processes?.length == 0)
                                  ? Container(
                                      height: 50,
                                      child: Center(
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .notData)),
                                    )
                                  : Wrap(
                                      children: List.generate(
                                          data.processes.length, (index) {
                                        return Container(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 15, 10, 15),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                      'assets/images/check-ring.png'),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      '${data.processes[index].name ?? ''}: ',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat-M',
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 28,
                                                    right: 20,
                                                    top: 10),
                                                alignment: Alignment.topLeft,
                                                child: Text(data
                                                        .processes[index]
                                                        .description ??
                                                    AppLocalizations.of(context)
                                                        .notData),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            _buildTestHeader(context,
                                '${AppLocalizations.of(context).testCategory} (${state.medicalTest.length}) '),
                            buildVisibilityWidget(
                              isTestExpand,
                              state,
                              (state?.medicalTest?.length == 0)
                                  ? Container(
                                      height: 50,
                                      child: Center(
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .notData)),
                                    )
                                  : Wrap(
                                      children: List.generate(
                                        state.medicalTest.length,
                                        (index) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                state.medicalTest[index].name,
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat-M',
                                                    fontSize: 15),
                                              ),
                                              Divider()
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                            ),
                            SizedBox(height: 15),
                            _buildExamHeader(context,
                                '${AppLocalizations.of(context).examinationCategory} (${state.physicalExam.length})'),
                            buildVisibilityWidget(
                              isExamExpand,
                              state,
                              (state?.physicalExam?.length == 0)
                                  ? Container(
                                      height: 50,
                                      child: Center(
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .notData)),
                                    )
                                  : Wrap(
                                      children: List.generate(
                                        state.physicalExam.length,
                                        (index) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                state.physicalExam[index].name,
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat-M',
                                                    fontSize: 15),
                                              ),
                                              Divider()
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                            ),
                            SizedBox(height: 15),
                            _buildOtherHeader(context,
                                '${AppLocalizations.of(context).otherCategory} (${state.otherExam.length}) '),
                            buildVisibilityWidget(
                              isotherCategoryExpand,
                              state,
                              (state?.otherExam?.length == 0)
                                  ? Container(
                                      height: 50,
                                      child: Center(
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .notData)),
                                    )
                                  : Wrap(
                                      children: List.generate(
                                        state.otherExam.length,
                                        (index) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                state.otherExam[index].name,
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat-M',
                                                    fontSize: 15),
                                              ),
                                              Divider()
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                            ),
                            SizedBox(height: 15),
                            _buildNoticeHeader(context,
                                AppLocalizations.of(context).noteThings),
                            buildVisibilityWidget(
                              isNOteExpand,
                              state,
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                // padding: EdgeInsets.fromLTRB(40, 15, 10, 15),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8)),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(
                                        AppLocalizations.of(context).forTest,
                                        style: TextStyle(
                                            fontFamily: 'Montserrat-M',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      padding: const EdgeInsets.only(
                                          top: 13.0, left: 10),
                                      // child: Text(
                                      //   data?.note,
                                      //   style:TextStyle(
                                      //  fontFamily: 'Montserrat-M',fontSize: 15),
                                      // ),
                                      child: (data?.note == null)
                                          ? Container(
                                              height: 50,
                                              child: Center(
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .notData)),
                                            )
                                          : Html(
                                              data: data?.note ?? "",
                                              defaultTextStyle: TextStyle(
                                                  fontFamily: 'Montserrat-M',
                                                  fontSize: 15,
                                                  color: Colors.black),
                                              // padding: EdgeInsets.only(top: 10.0),
                                              onLinkTap: (url) {
                                                print("Opening $url...");
                                              },
                                              customRender: (node, children) {
                                                if (node is dom.Element) {
                                                  switch (node.localName) {
                                                    case "custom_tag": // using this, you can handle custom tags in your HTML
                                                      return Column(
                                                          children: children);
                                                  }
                                                }
                                                return null;
                                              },
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            (_branchId != null || !haveBranch)
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OrderScreen(
                                              gender: data.gender,
                                              fromAge: data.fromAge,
                                              toAge: data.toAge,
                                              companyId: data.companyId,
                                              useBookingTime:
                                                  data.useBookingTime,
                                              useStaff: data.useStaff,
                                              address: data.companyAddress,
                                              companyType:
                                                  this.widget.companyType,
                                              servicePackageId:
                                                  this.widget.serviceId.id,
                                              isReschedule: false,
                                              branchId: _branchId ?? '',
                                              contact: widget?.contact),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          bottom: 20, left: 20, right: 20),
                                      padding: const EdgeInsets.only(
                                          top: 15, bottom: 15),
                                      // height: useMobileLayout ? 33 : 48,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: AppColor.purple,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(
                                            'assets/imgclinic/ic_calendar.png',
                                            width: useMobileLayout ? 18 : 30,
                                            height: useMobileLayout ? 18 : 30,
                                          ),
                                          SizedBox(
                                            width: 6.8,
                                          ),
                                          Text(
                                            AppLocalizations.of(context).book,
                                            style: TextStyle(
                                                fontFamily: 'Montserrat-M',
                                                fontSize:
                                                    useMobileLayout ? 15 : 26,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ))
                                : Center(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: 20, left: 20, right: 20),
                                      child: Text(
                                          AppLocalizations.of(context)
                                              .selectBranch,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColor.orangeColor,
                                            fontSize: 18,
                                            fontFamily: 'Montserrat-M',
                                          )),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    );
            }),
      ),
    );
  }

  InkWell _buildWhyHeader(BuildContext context, String text) {
    return InkWell(
      onTap: () {
        setState(() {
          isWhyExpand = !isWhyExpand;
          print(isWhyExpand);
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          // border: (isWhyExpand) ? Border.all(color: AppColor.ocenBlue) : null,
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 15, color: Colors.black12, offset: Offset(0, 0))
          ],
          // color: Colors.white,
        ),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                border:
                    (isWhyExpand) ? Border.all(color: AppColor.ocenBlue) : null,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5,
                      color: Colors.black12,
                      offset: Offset(0, 0))
                ],
                shape: BoxShape.circle,
                color: (isWhyExpand) ? AppColor.ocenBlue : Colors.white),
            child: (isWhyExpand)
                ? Icon(Icons.clear_outlined)
                : Icon(Icons.add_outlined),
          ),
          title: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat-M',
            ),
          ),
        ),
      ),
    );
  }

  InkWell _buildProcessHeader(BuildContext context, String text) {
    return InkWell(
      onTap: () {
        setState(() {
          isProcessExpand = !isProcessExpand;
          print(isProcessExpand);
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: (isProcessExpand)
              ? BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8))
              : BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 15, color: Colors.black12, offset: Offset(0, 0))
          ],
          // color: Colors.white,
        ),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                border: (isProcessExpand)
                    ? Border.all(color: AppColor.ocenBlue)
                    : null,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5,
                      color: Colors.black12,
                      offset: Offset(0, 0))
                ],
                shape: BoxShape.circle,
                color: (isProcessExpand) ? AppColor.ocenBlue : Colors.white),
            child: (isProcessExpand)
                ? Icon(Icons.clear_outlined)
                : Icon(Icons.add_outlined),
          ),
          title: Text(
            text,
            style: TextStyle(
                fontFamily: 'Montserrat-M',
                fontSize: 15,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  InkWell _buildTestHeader(BuildContext context, String text) {
    return InkWell(
      onTap: () {
        setState(() {
          isTestExpand = !isTestExpand;
          print(isTestExpand);
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: (isTestExpand)
              ? BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8))
              : BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 15, color: Colors.black12, offset: Offset(0, 0))
          ],
          // color: Colors.white,
        ),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                border: (isTestExpand)
                    ? Border.all(color: AppColor.ocenBlue)
                    : null,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5,
                      color: Colors.black12,
                      offset: Offset(0, 0))
                ],
                shape: BoxShape.circle,
                color: (isTestExpand) ? AppColor.ocenBlue : Colors.white),
            child: (isTestExpand)
                ? Icon(Icons.clear_outlined)
                : Icon(Icons.add_outlined),
          ),
          title: Text(
            text,
            style: TextStyle(
                fontFamily: 'Montserrat-M',
                fontSize: 15,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  InkWell _buildOtherHeader(BuildContext context, String text) {
    return InkWell(
      onTap: () {
        setState(() {
          isotherCategoryExpand = !isotherCategoryExpand;
          print(isotherCategoryExpand);
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: (isotherCategoryExpand)
              ? BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8))
              : BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 15, color: Colors.black12, offset: Offset(0, 0))
          ],
          // color: Colors.white,
        ),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                border: (isotherCategoryExpand)
                    ? Border.all(color: AppColor.ocenBlue)
                    : null,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5,
                      color: Colors.black12,
                      offset: Offset(0, 0))
                ],
                shape: BoxShape.circle,
                color:
                    (isotherCategoryExpand) ? AppColor.ocenBlue : Colors.white),
            child: (isotherCategoryExpand)
                ? Icon(Icons.clear_outlined)
                : Icon(Icons.add_outlined),
          ),
          title: Text(
            text,
            style: TextStyle(
                fontFamily: 'Montserrat-M',
                fontSize: 15,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  InkWell _buildExamHeader(BuildContext context, String text) {
    return InkWell(
      onTap: () {
        setState(() {
          isExamExpand = !isExamExpand;
          print(isExamExpand);
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: (isExamExpand)
              ? BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8))
              : BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 15, color: Colors.black12, offset: Offset(0, 0))
          ],
          // color: Colors.white,
        ),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                border: (isExamExpand)
                    ? Border.all(color: AppColor.ocenBlue)
                    : null,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5,
                      color: Colors.black12,
                      offset: Offset(0, 0))
                ],
                shape: BoxShape.circle,
                color: (isExamExpand) ? AppColor.ocenBlue : Colors.white),
            child: (isExamExpand)
                ? Icon(Icons.clear_outlined)
                : Icon(Icons.add_outlined),
          ),
          title: Text(
            text,
            style: TextStyle(
                fontFamily: 'Montserrat-M',
                fontSize: 15,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  InkWell _buildNoticeHeader(BuildContext context, String text) {
    return InkWell(
      onTap: () {
        setState(() {
          isNOteExpand = !isNOteExpand;
          print(isNOteExpand);
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: (isNOteExpand)
              ? BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8))
              : BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 15, color: Colors.black12, offset: Offset(0, 0))
          ],
          // color: Colors.white,
        ),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                border: (isNOteExpand)
                    ? Border.all(color: AppColor.ocenBlue)
                    : null,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5,
                      color: Colors.black12,
                      offset: Offset(0, 0))
                ],
                shape: BoxShape.circle,
                color: (isNOteExpand) ? AppColor.ocenBlue : Colors.white),
            child: (isNOteExpand)
                ? Icon(Icons.clear_outlined)
                : Icon(Icons.add_outlined),
          ),
          title: Text(
            text,
            style: TextStyle(
                fontFamily: 'Montserrat-M',
                fontSize: 15,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  buildVisibilityWidget(
      bool isExpand, ServicePackageState state, Widget child) {
    return Visibility(
      visible: isExpand,
      child: Container(
          margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
          padding: EdgeInsets.fromLTRB(40, 15, 10, 15),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.ocenBlue),
            // border: Border.,
            // border: Border(
            //   left: BorderSide(color: AppColor.ocenBlue),
            //   right: BorderSide(color: AppColor.ocenBlue),
            //   top: BorderSide.none,
            //   bottom: BorderSide(color: AppColor.ocenBlue),
            // ),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8)),
            color: Colors.white,
          ),
          child: child),
    );
  }

  buildBranchList(BuildContext context) {
    return BlocProvider<ServicePackageEvent, ServicePackageState,
            ServicePackageBloc>(
        bloc: bloc,
        builder: (state) {
          List<BanchModel> _list = bloc?.state?.branchList;
          haveBranch = _list.isNotEmpty;
          //List<bool> _check = [];
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 190,
            margin: EdgeInsets.only(left: 20),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _branchId = _list[index]?.id;
                        _index = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 15, right: 15, bottom: 10),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 15,
                                color: Colors.black12,
                                offset: Offset(0, 0))
                          ],
                          border: (_index != index || _index == null)
                              ? Border.all(color: Colors.transparent, width: 0)
                              : Border.all(
                                  color: AppColor.orangeColor, width: 2.5),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      width: 125,
                      // height: MediaQuery.of(context).size.height * 0,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: AppColor.ocenBlue,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10))),
                            height: 105,
                            width: double.infinity,
                          ),
                          Positioned(
                            right: 5,
                            top: 90,
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColor.purple,
                              ),
                              child: Icon(Icons.bookmark_border_outlined,
                                  color: Colors.white),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              height: 85,
                              width: 125,
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.only(left: 12, bottom: 5),
                              child: RichText(
                                // maxLines: 3,
                                softWrap: false,
                                text: TextSpan(
                                    text: '1,3 Km\n',
                                    style: TextStyle(
                                        fontSize: 10, color: AppColor.purple),
                                    children: [
                                      TextSpan(
                                        text: '${_list[index].name}\n',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            height: 1.5),
                                      ),
                                      TextSpan(
                                          text: 'Xem đường đi',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 11,
                                          )),
                                    ]),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          );
        });
  }

  buildPrice(DetailServiceModel data) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20, top: 20),
          alignment: Alignment.topLeft,
          child: Text(
            AppLocalizations.of(context).servicePrice,
            style: TextStyle(
                fontFamily: 'Montserrat-M', color: Colors.grey, fontSize: 14),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 20, top: 5),
          alignment: Alignment.topLeft,
          child: Text(
            "${money.format(data?.price ?? 0)} đ",
            style: TextStyle(
                fontFamily: 'Montserrat-M',
                color: AppColor.darkPurple,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Container buildInforContainer(bool useMobileLayout, DetailServiceModel data) {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 35, 20, 10),
        padding:
            const EdgeInsets.only(top: 15, left: 11.7, right: 7, bottom: 15),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(blurRadius: 15, color: Colors.black12, offset: Offset(0, 0))
        ], borderRadius: BorderRadius.circular(5), color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                        width: useMobileLayout ? 16 : 28,
                        height: useMobileLayout ? 16 : 28,
                        child: Image.asset('assets/images/check-ring.png')),
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        _gender(context, data?.gender),
                        style: TextStyle(
                            // fontFamily: 'Montserrat-M',
                            fontSize: useMobileLayout ? 15 : 26,
                            color: Color(0xFF9093A3)),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 9,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        child: Image.asset(
                      'assets/images/check-ring.png',
                      width: useMobileLayout ? 16 : 28,
                      height: useMobileLayout ? 16 : 28,
                    )),
                    Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          _birthday(context, data?.fromAge, data?.toAge),
                          style: TextStyle(
                              // fontFamily: 'Montserrat-M',
                              fontSize: useMobileLayout ? 15 : 26,
                              color: Color(0xFF9093A3)),
                        ))
                  ],
                ),
              ],
            )),
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/check-ring.png',
                      width: useMobileLayout ? 16 : 28,
                      height: useMobileLayout ? 16 : 28,
                    ),
                    Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "${data?.test ?? ''} ${AppLocalizations.of(context).test}",
                          style: TextStyle(
                              // fontFamily: 'Montserrat-M',
                              fontSize: useMobileLayout ? 15 : 26,
                              color: Color(0xFF9093A3)),
                        ))
                  ],
                ),
                SizedBox(
                  height: 9,
                ),
                Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/check-ring.png',
                      width: useMobileLayout ? 16 : 28,
                      height: useMobileLayout ? 16 : 28,
                    ),
                    Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "${data?.exam ?? 0} ${AppLocalizations.of(context).examination}",
                          style: TextStyle(
                              // fontFamily: 'Montserrat-M',
                              fontSize: useMobileLayout ? 15 : 26,
                              color: Color(0xFF9093A3)),
                        ))
                  ],
                )
              ],
            ))
          ],
        ));
  }

  _gender(BuildContext context, int gender) {
    if (gender == 1) {
      return AppLocalizations.of(context).male;
    } else if (gender == 2) {
      return AppLocalizations.of(context).female;
    } else if (gender == null) {
      return AppLocalizations.of(context).both;
    }
  }

  _birthday(BuildContext context, int fromAge, int toAge) {
    if (fromAge != null && toAge != null) {
      return "${AppLocalizations.of(context).from} $fromAge - $toAge ${AppLocalizations.of(context).yearOld}";
    } else if (fromAge != null && toAge == null) {
      return "${AppLocalizations.of(context).from} $fromAge ${AppLocalizations.of(context).yearUp}";
    } else if (fromAge == null && toAge != null) {
      return "${AppLocalizations.of(context).from} $toAge ${AppLocalizations.of(context).down}";
    } else if (fromAge == null && toAge == null) {
      return AppLocalizations.of(context).allAge;
    }
  }

  // calculateAge(DateTime birthDate) {
  //   DateTime currentDate = DateTime.now();
  //   int age = currentDate.year - birthDate.year;
  //   int month1 = currentDate.month;
  //   int month2 = birthDate.month;
  //   if (month2 > month1) {
  //     age--;
  //   } else if (month1 == month2) {
  //     int day1 = currentDate.day;
  //     int day2 = birthDate.day;
  //     if (day2 > day1) {
  //       age--;
  //     }
  //   }
  //   return age;
  // }
}
