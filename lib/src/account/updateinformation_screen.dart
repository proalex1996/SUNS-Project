import 'dart:io';
import 'dart:math';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/common/dimension.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/button.dart';
import 'package:suns_med/src/account/session_service_user_background_image_bloc.dart';
import 'package:suns_med/src/account/update_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';

class UpdateInformationScreen extends StatefulWidget {
  @override
  _UpdateInformationScreenState createState() =>
      _UpdateInformationScreenState();
}

class _UpdateInformationScreenState extends State<UpdateInformationScreen> {
  final bloc = SessionBloc();
  final picker = ImagePicker();
  final commonBloc = UserBackgroundBloc();
  int _count = 0;
  File _image;

  var rng = new Random();

  Future getImageAsCamera() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, maxWidth: 300, maxHeight: 300);
    _setImage(pickedFile);
  }

  Future getImageAsGallery() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxWidth: 300, maxHeight: 300);
    _setImage(pickedFile);
  }

  _setImage(PickedFile pickedFile) {
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        Navigator.pop(context);
        Flushbar(
          title: "Đồng ý đổi avatar ?",
          message: "Đồng ý ?",
          // duration: Duration(seconds: 5),
          borderRadius: 20,
          icon: Icon(
            Icons.check_circle_outline_sharp,
            color: Colors.green,
          ),
          mainButton: Row(
            children: [
              FlatButton(
                onPressed: () async {
                  // avatarBloc.dispatch(UploadAvatarEvent(image: _image));

                  bloc.dispatch(EventUploadAvatar(image: _image));

                  // bloc.dispatch(EventGetUser());
                },
                child: Text(
                  "Ok",
                  style: TextStyle(
                      fontFamily: 'Montserrat-M', color: AppColor.white),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  // bloc.dispatch(EventUploadAvatar(image: _image));
                  _image = null;
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancle",
                  style: TextStyle(
                      fontFamily: 'Montserrat-M', color: AppColor.white),
                ),
              ),
            ],
          ),
        )..show(context);
      });
    } else {
      print('No image selected.');
    }
  }

  checkPermissionOpenCamera() async {
    if (await Permission.camera.request().isGranted) {
      getImageAsCamera();
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text('Cho phép Gcare sử dụng máy ảnh'),
                content: Text(
                    'Ứng dụng này cần quyền truy cập camera để chụp ảnh và tải ảnh hồ sơ người dùng lên'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      'Từ chối',
                      style: TextStyle(
                          fontFamily: 'Montserrat-M', color: Colors.black),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: Text('Cho phép'),
                    onPressed: () => openAppSettings(),
                  ),
                ],
              ));
    }
  }

  checkPermissionOpenGallery() async {
    if (await Permission.photos.request().isGranted) {
      getImageAsGallery();
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text('Cho phép Gcare sử dụng bộ nhớ điện thoại'),
                content: Text(
                    'Khi đó bạn có thể chia sẻ từ thư viện ảnh, cũng như bật tính năng khác cho ảnh và video'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      'Từ chối',
                      style: TextStyle(
                          fontFamily: 'Montserrat-M', color: Colors.black),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: Text('Cho phép'),
                    onPressed: () => openAppSettings(),
                  ),
                ],
              ));
    }
  }

  @override
  void initState() {
    bloc.dispatch(EventGetUser());
    commonBloc.dispatch(EventLoadBackground());
    imageCache.clearLiveImages();
    imageCache.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context);
    return BlocProvider<EventSession, StateSession, SessionBloc>(
        bloc: bloc,
        builder: (state) {
          return Scaffold(
            backgroundColor: AppColor.veryLightPinkFour,
            appBar: const TopAppBar(),
            body: RefreshIndicator(
              onRefresh: _refreshHome,
              child: _buildBody(),
            ),
          );
        });
  }

  Future<Null> _refreshHome() async {
    bloc.dispatch(EventGetUser());
    // await Future.wait([
    //   Future.delayed(const Duration(microseconds: 500), () {
    //     imageCache.clearLiveImages();
    //     imageCache.clear();
    //   })
    // ]);

    // commonBloc.dispatch(EventLoadBackground());
    // setState(() {});
  }

  _buildBody() {
    return BlocProvider<EventSession, StateSession, SessionBloc>(
        bloc: bloc,
        builder: (state) {
          int _index = state.user?.gender;
          String date = state.user?.birthDay?.toIso8601String();
          DateTime dateTime = DateTime.parse(date);
          return SingleChildScrollView(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  children: [
                    // BlocProvider<UserBackgroundEvent, UserBackgroundState,
                    //         UserBackgroundBloc>(
                    //     bloc: commonBloc,
                    //     builder: (state) {
                    //       return (state.urlBackground != null)
                    //           ? Image.network(
                    //               state.urlBackground,
                    //               width: double.infinity,
                    //               height: height(context) * 0.2,
                    //               fit: BoxFit.cover,
                    //             )
                    //           : Image.asset(
                    //               'assets/images/cover6.png',
                    //               width: double.infinity,
                    //               height: height(context) * 0.2,
                    //               fit: BoxFit.cover,
                    //             );
                    //     }),

                    imgBackgroud(context, state.user?.fullName, true),
                    // Container(
                    //   height: 141,
                    //   color: Colors.white,
                    //   padding:
                    //       const EdgeInsets.only(left: 21, right: 20, top: 70),
                    //   child: Column(
                    //     children: [
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text(
                    //             'Tổng điểm: ${state.userSummaryReport?.totalPoint ?? 0}',
                    //             style:TextStyle(
                    //     fontFamily: 'Montserrat-M',fontSize: 16),
                    //           ),
                    //           Text(
                    //             state.user?.totalLike == null
                    //                 ? ""
                    //                 : "Tổng like: ${state.userSummaryReport?.totalLike ?? 0}",
                    //             style:TextStyle(
                    //    fontFamily: 'Montserrat-M',fontSize: 16),
                    //           ),
                    //         ],
                    //       ),
                    //       SizedBox(
                    //         height: 22,
                    //       ),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text(
                    //             'Tổng tin Post: ${state.userSummaryReport?.totalPost ?? 0}',
                    //             style:TextStyle(
                    //   fontFamily: 'Montserrat-M',fontSize: 16),
                    //           ),
                    //           Text(
                    //             'Tổng Comment: ${state.userSummaryReport?.totalComment ?? 0}',
                    //             style:TextStyle(
                    //  fontFamily: 'Montserrat-M',fontSize: 16),
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Container(
                      width: width(context),
                      // height: height(context),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.white,
                            Colors.white38,
                            Color(0xFFF2F8FF)
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            width(context) * 0.04,
                            height(context) * 0.01,
                            width(context) * 0.04,
                            height(context) * 0.06),
                        child: Column(
                          children: [
                            cardProfile(
                                context,
                                state.user?.fullName,
                                state.user?.phoneNumber,
                                state.user?.email,
                                state.user?.personalNumber,
                                "${state.user?.address} ${state.user?.ward ?? ""} ${state.user?.district ?? ""} ${state.user?.province ?? 'Chưa cập nhật'}",
                                _index,
                                formatDate(dateTime)),
                            cardQRcode(
                                context,
                                state.user?.barcode == null
                                    ? ""
                                    : state.user?.barcode)
                          ],
                        ),
                      ),
                    ),

                    // Container(
                    //   margin: EdgeInsets.only(top: 10),
                    //   padding:
                    //       const EdgeInsets.only(left: 20, right: 19, top: 29),
                    //   color: Colors.white,
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       _buildRowContent(
                    //           'Họ và tên:',
                    //           state.user?.fullName == null
                    //               ? "Chưa cập nhật họ tên !"
                    //               : '${state.user?.fullName}'),
                    //       Divider(
                    //         indent: 20.5,
                    //         endIndent: 20.5,
                    //         height: 25,
                    //       ),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text(
                    //             'Giới tính:',
                    //             style:TextStyle(
                    //   fontFamily: 'Montserrat-M',fontSize: 16),
                    //           ),
                    //           Container(
                    //             height: 25,
                    //             width: 72,
                    //             margin: EdgeInsets.only(left: 131),
                    //             decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(5),
                    //                 border:
                    //                     Border.all(color: AppColor.paleGrey)),
                    //             child: CustomButton(
                    //               text: 'Nữ',
                    //               color: _index == 1
                    //                   ? AppColor.paleLilacTwo
                    //                   : Colors.white,
                    //               style:TextStyle(
                    //    fontFamily: 'Montserrat-M',
                    //                   fontSize: 16, color: Colors.black),
                    //               radius: BorderRadius.circular(5),
                    //               onPressed: () {
                    //                 setState(() {
                    //                   _index = 1;
                    //                 });
                    //               },
                    //             ),
                    //           ),
                    //           Container(
                    //             height: 25,
                    //             width: 72,
                    //             decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(5),
                    //                 border:
                    //                     Border.all(color: AppColor.paleGrey)),
                    //             child: CustomButton(
                    //               text: 'Nam',
                    //               color: _index == 0
                    //                   ? AppColor.paleLilacTwo
                    //                   : Colors.white,
                    //               radius: BorderRadius.circular(5),
                    //               style:TextStyle(
                    //     fontFamily: 'Montserrat-M',
                    //                   fontSize: 16, color: Colors.black),
                    //               onPressed: () {
                    //                 Navigator.push(
                    //                     context,
                    //                     MaterialPageRoute(
                    //                       builder: (ctx) => UpdateScreen(
                    //                         isUpdateAndCreated: false,
                    //                       ),
                    //                     ));
                    //                 // setState(() {
                    //                 //   _index = 0;
                    //                 // });
                    //               },
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       Divider(
                    //         indent: 20.5,
                    //         endIndent: 20.5,
                    //         height: 25,
                    //       ),
                    //       _buildRowContent(
                    //           'Email:',
                    //           state.user?.email == null
                    //               ? "Chưa cập nhật Email!"
                    //               : '${state.user?.email}'),
                    //       Divider(
                    //         indent: 20.5,
                    //         endIndent: 20.5,
                    //         height: 25,
                    //       ),
                    //       _buildRowContent(
                    //         'Ngày tháng năm sinh',
                    //         DateFormat.yMMMd('vi').format(dateTime),
                    //       ),
                    //       Divider(
                    //         indent: 20.5,
                    //         endIndent: 20.5,
                    //         height: 25,
                    //       ),
                    //       _buildRowContent(
                    //           'Số điện thoại',
                    //           state.user?.phoneNumber == null
                    //               ? ""
                    //               : state.user?.phoneNumber),
                    //       Divider(
                    //         indent: 20.5,
                    //         endIndent: 20.5,
                    //         height: 25,
                    //       ),
                    //       _buildRowContent(
                    //           'Số CMND',
                    //           state.user?.personalNumber == null
                    //               ? "Chưa cập nhật CMND"
                    //               : '${state.user?.personalNumber}'),
                    //       Divider(
                    //         indent: 20.5,
                    //         endIndent: 20.5,
                    //         height: 25,
                    //       ),
                    //       _buildRowAddress(state.user?.address == null
                    //           ? "Chưa cập nhật địa chỉ !"
                    //           : "${state.user?.address} ${state.user?.ward ?? ""} ${state.user?.district ?? ""} ${state.user?.province}"),
                    //       Divider(
                    //         indent: 20.5,
                    //         endIndent: 20.5,
                    //         height: 25,
                    //       ),
                    //       _buildQRCode(state.user?.barcode == null
                    //           ? ""
                    //           : state.user?.barcode),
                    //       _buildCustomButton()
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
                Positioned(
                  top: height(context) * 0.12,
                  child:
                      // state.user?.avatar == null
                      //     ? CircleAvatar(
                      //         maxRadius: 50,
                      //         backgroundImage:
                      //             AssetImage("assets/images/avatar2.png"),
                      //       )
                      // ? Shimmer.fromColors(
                      //     child: CircleAvatar(
                      //       maxRadius: 50,
                      //     ),
                      //     baseColor: AppColor.paleGreyFour,
                      //     highlightColor: AppColor.whitetwo,
                      //   )
                      // :
                      _buildToolAddImage(state.user?.avatar),
                ),
              ],
            ),
          );
        });
  }

  _buildQRCode(String data) {
    return Container(
        padding: const EdgeInsets.all(30),
        alignment: Alignment.bottomCenter,
        child: QrImage(
          data: data,
        ));
  }

  _buildCustomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 26),
      child: CustomButton(
        color: AppColor.deepBlue,
        text: 'Cập nhật thông tin',
        style: TextStyle(
            fontFamily: 'Montserrat-M', fontSize: 16, color: Colors.white),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => UpdateScreen(
                  isUpdateAndCreated: false,
                ),
              ));
        },
        radius: BorderRadius.circular(26),
      ),
    );
  }

  _buildRowAddress(String address) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateScreen(
                isUpdateAndCreated: false,
              ),
            ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Địa chỉ: ',
            style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  address,
                  style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 16,
                      color: AppColor.battleshipGrey),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey,
                  size: 15,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateScreen(
                          isUpdateAndCreated: false,
                        ),
                      ));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildRowContent(String texttitle, String textcontent) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateScreen(
                isUpdateAndCreated: false,
              ),
            ));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            texttitle,
            style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
          ),
          Row(
            children: [
              Text(
                textcontent,
                style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: 16,
                    color: AppColor.battleshipGrey),
              ),
              SizedBox(
                width: 10,
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey,
                  size: 15,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateScreen(
                        isUpdateAndCreated: false,
                      ),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Future _showAlert(BuildContext context, String message) async {
    return showDialog(
        context: context,
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: _customDialog(context),
        ));
  }

  Future _showContainerImage(BuildContext context, String message) async {
    return showDialog(
        context: context,
        child: Stack(
          children: [
            Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: BlocProvider<EventSession, StateSession, SessionBloc>(
                  bloc: bloc,
                  builder: (state) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        color: AppColor.white,
                      ),
                      child: PhotoView(
                          imageProvider: NetworkImage(
                              "${state.user?.avatar}?rd=${++_count}")),
                    );
                  }),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ));
  }

  Future _showDialogChooseAvatar(BuildContext context, String message) async {
    return showDialog(
      context: context,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
            padding: const EdgeInsets.all(10),
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: AppColor.white,
            ),
            child: BlocProvider<EventSession, StateSession, SessionBloc>(
                bloc: bloc,
                builder: (state) {
                  return Column(
                    children: <Widget>[
                      Container(
                        padding:
                            const EdgeInsets.only(left: 10, right: 40, top: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            state.user.avatar == null
                                ? GestureDetector(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.image,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          'Xem hình ảnh',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat-M',
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  )
                                : GestureDetector(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(Icons.image),
                                        Text('Xem hình ảnh'),
                                      ],
                                    ),
                                    onTap: () =>
                                        _showContainerImage(context, "message")
                                            .then((value) {
                                      setState(() {});
                                    }),
                                  ),
                            Divider(),
                            GestureDetector(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.image_search),
                                  Text('Thay đổi hình ảnh'),
                                ],
                              ),
                              onTap: () =>
                                  _showAlert(context, message).then((t) {
                                setState(() {});
                              }),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                })),
      ),
    );
  }

  _customDialog(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          color: AppColor.white,
        ),
        child: Column(
          children: <Widget>[
            Text(
              'Chọn ảnh',
              style: TextStyle(
                  fontFamily: 'Montserrat-M',
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Chọn ảnh từ nguồn',
              style: TextStyle(
                fontFamily: 'Montserrat-M',
                fontSize: 16,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 40, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        size: 60,
                        color: AppColor.deepBlue,
                      ),
                      onPressed: Platform.isIOS
                          ? checkPermissionOpenCamera
                          : getImageAsCamera),
                  IconButton(
                      icon: Icon(
                        Icons.image,
                        color: AppColor.deepBlue,
                        size: 60,
                      ),
                      onPressed: Platform.isIOS
                          ? checkPermissionOpenGallery
                          : getImageAsGallery),
                ],
              ),
            ),
          ],
        ),
      );

  _buildToolAddImage(String avatar) {
    return GestureDetector(
      onTap: () => _showDialogChooseAvatar(context, 'massage').then((t) {
        setState(() {});
      }),
      child: Container(
        padding: const EdgeInsets.all(5),
        //color: Colors.white,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(500),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.white10, spreadRadius: 1),
          ],
        ),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(1),
              child: CircleAvatar(
                maxRadius: 50,
                backgroundImage: _image == null
                    ? avatar == null
                        ? AssetImage("assets/images/avatar2.png")
                        //To do se verified code nay
                        : NetworkImage("$avatar?rd=${rng.nextInt(100)}")
                    : FileImage(_image),
                // _image == null ? ""  FileImage(_image),
              ),
            ),
            Positioned(
              left: 77,
              top: 72,
              child: CircleAvatar(
                backgroundColor: AppColor.lightPeach,
                minRadius: 10,
                child: Icon(
                  Icons.photo_camera,
                  size: 12,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
        //  Container(width: 100, height: 100, child: Image.file(_image)),
      ),
    );
  }

  Widget miniAvatar(String avatar) {
    return CircleAvatar(
      maxRadius: 18,
      backgroundImage: _image == null
          ? avatar == null
              ? AssetImage("assets/images/avatar2.png")
              //To do se verified code nay
              : NetworkImage("$avatar?rd=${rng.nextInt(100)}")
          : FileImage(_image),
      // _image == null ? ""  FileImage(_image),
    );
  }
}

Widget buildToolAddImage(String avatar) {
  var rng = new Random();
  return Container(
    padding: const EdgeInsets.all(5),
    //color: Colors.white,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(500),
      color: Colors.white,
      boxShadow: [
        BoxShadow(color: Colors.white10, spreadRadius: 1),
      ],
    ),
    child: Stack(
      children: [
        Container(
          padding: EdgeInsets.all(1),
          child: CircleAvatar(
              maxRadius: 50,
              backgroundImage: avatar == null
                  ? AssetImage("assets/images/avatar2.png")
                  //To do se verified code nay
                  : NetworkImage("$avatar?rd=${rng.nextInt(100)}")
              // _image == null ? ""  FileImage(_image),
              ),
        ),
        Positioned(
          left: 77,
          top: 72,
          child: CircleAvatar(
            backgroundColor: AppColor.lightPeach,
            minRadius: 10,
            child: Icon(
              Icons.photo_camera,
              size: 12,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    ),
    //  Container(width: 100, height: 100, child: Image.file(_image)),
  );
}

Widget miniAvatar(String avatar) {
  var rng = new Random();
  return CircleAvatar(
      maxRadius: 18,
      backgroundImage: avatar == null
          ? AssetImage("assets/images/avatar2.png")
          //To do se verified code nay
          : NetworkImage("$avatar?rd=${rng.nextInt(100)}")

      // _image == null ? ""  FileImage(_image),
      );
}

Widget cardProfile(BuildContext context, String name, String phone, String mail,
    String contact, String address, int gene, String birth) {
  String unDone = 'Chưa cập nhật';
  return Container(
    margin: EdgeInsets.only(top: height(context) * 0.1),
    height: 300,
    width: width(context) * 0.9,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 10),
      ],
    ),
    child: Column(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => UpdateScreen(
                              isUpdateAndCreated: false,
                            ),
                          ));
                    },
                    child: title(context,
                        AppLocalizations.of(context).personalInformation)),
                SizedBox(
                  height: 10,
                ),
                rowDataProfileName(context, 'user_profile.png', name ?? unDone),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (gene == 1
                        ? rowDataProfile(context, 'gender_profile.png',
                            AppLocalizations.of(context).male)
                        : (gene == 2)
                            ? rowDataProfile(context, 'gender_profile.png',
                                AppLocalizations.of(context).female)
                            : rowDataProfile(context, 'gender_profile.png',
                                AppLocalizations.of(context).undefined)),
                    SizedBox(
                      width: width(context) * 0.1,
                    ),
                    rowDataProfile(
                        context, 'birth_profile.png', birth ?? unDone),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                rowDataProfile(context, 'mail_profile.png', mail ?? unDone),
                SizedBox(
                  height: 20,
                ),
                rowDataProfile(context, 'phone_profile.png', phone ?? unDone),
                SizedBox(
                  height: 20,
                ),
                rowDataProfile(
                    context, 'contact_profile.png', contact ?? unDone),
                SizedBox(
                  height: 20,
                ),
                rowDataProfile(
                    context, 'address_profile.png', address ?? unDone),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget cardQRcode(BuildContext context, String code) {
  return Container(
      margin: EdgeInsets.only(top: height(context) * 0.05),
      height: isTablet(context) ? 425 : height(context) * 0.63,
      width: width(context) * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(top: height(context) * 0.02),
              child: title(context, AppLocalizations.of(context).yourQr)),
          SizedBox(
            height: 10,
          ),
          Container(
            // padding: EdgeInsets.fromLTRB(width(context) * 0.1,
            //     height(context) * 0.01, width(context) * 0.1, 0),
            margin: EdgeInsets.all(10),
            child: Center(
              child: QrImage(
                data: code,
                size: isTablet(context)
                    // ? (height(context) * 0.01) * (width(context) * 0.1)
                    ? 290
                    : height(context) * 0.45,
              ),
            ),
          ),
        ],
      ));
}

Widget rowDataProfile(
  BuildContext context,
  String icon,
  String data,
) {
  return Expanded(
      child: Container(
    padding:
        EdgeInsets.fromLTRB(width(context) * 0.03, 0, width(context) * 0.03, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // ImageIcon(
        //   AssetImage('assets/images/profile/$icon'),
        //   color: Color(0xFF2E3E5C),
        //   size: 30,
        // ),
        Image.asset(
          'assets/images/profile/$icon',
          color: Color(0xFF2E3E5C),
          width: 22,
          height: 22,
        ),
        SizedBox(
          width: width(context) * 0.03,
        ),
        Expanded(
          child: Text(
            data,
            style: TextStyle(
                fontFamily: 'Montserrat-M',
                color: Color(0xFF2E3E5C),
                fontSize: 14,
                fontWeight: FontWeight.normal),
            overflow: TextOverflow.fade,
            maxLines: 5,
          ),
        )
      ],
    ),
  ));
}

Widget rowDataProfileName(
  BuildContext context,
  String icon,
  String data,
) {
  return Expanded(
      child: Container(
    padding:
        EdgeInsets.fromLTRB(width(context) * 0.03, 0, width(context) * 0.03, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // ImageIcon(
        //   AssetImage('assets/images/profile/$icon'),
        //   color: Color(0xFF2E3E5C),
        //   size: 30,
        // ),
        Image.asset(
          'assets/images/profile/$icon',
          color: Color(0xFF2E3E5C),
          width: 24,
          height: 24,
        ),
        SizedBox(
          width: width(context) * 0.03,
        ),
        Text(
          data,
          style: TextStyle(
              fontFamily: 'Montserrat-M',
              color: Color(0xFF2E3E5C),
              fontSize: 14,
              fontWeight: FontWeight.bold),
        )
      ],
    ),
  ));
}

Widget imgBackgroud(BuildContext context, String name, bool isBackButton) {
  return Container(
    width: width(context),
    height: height(context) * 0.2,
    decoration: BoxDecoration(
      color: Color(0xFFF4794C),
      image: DecorationImage(
        alignment: Alignment.bottomRight,
        image: AssetImage("assets/images/profile/pattern_background.png"),
        fit: BoxFit.none,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        (isBackButton)
            ? InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding:
                          EdgeInsets.fromLTRB(10, height(context) * 0.05, 0, 0),
                      child: ImageIcon(
                        AssetImage("assets/images/profile/arow_back.png"),
                        color: AppColor.white,
                      ),
                    )),
              )
            : Container(),
        Expanded(
          child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: height(context) * 0.02),
                child: Column(
                  children: [
                    Text('${AppLocalizations.of(context).hello},',
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            color: Colors.white,
                            fontSize: 24)),
                    Text(name,
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              )),
        ),
      ],
    ),
  );
}

Widget title(BuildContext context, String title) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: AppColor.lightGray),
    child: Text(
      title,
      style: TextStyle(
          fontFamily: 'Montserrat-M',
          color: AppColor.darkPurple,
          fontWeight: FontWeight.bold),
    ),
    padding: EdgeInsets.fromLTRB(10, 10, width(context) * 0.45, 10),
  );
}

String formatDate(DateTime date) {
  String formattedDate = DateFormat('dd/MM/yyyy').format(date);
  return formattedDate;
}
