import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/contact_model.dart';
import 'package:suns_med/src/Widgets/button.dart';
import 'package:suns_med/src/Widgets/textfield.dart';
import 'package:suns_med/src/model/image_model.dart';
import 'package:suns_med/src/order/session_confirminfo_bloc.dart';
import 'package:suns_med/src/order/session_createfile_bloc.dart';
import 'confirminfor_screen.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateInforScreen extends StatefulWidget {
  final bool useBookingTime;
  final DateTime dateTime;
  final String staffId, staffName, address, servicePackageId, branchId;
  final String birth;
  final int patientId;
  final ContactModel contact;

  final bool isCreated;
  final String timeSelect;
  CreateInforScreen(
      {this.isCreated = true,
      this.contact,
      @required this.dateTime,
      this.patientId,
      this.address,
      this.staffName,
      this.timeSelect,
      this.useBookingTime,
      this.staffId,
      this.birth,
      this.servicePackageId,
      this.branchId});
  @override
  _CreateInforScreenState createState() => _CreateInforScreenState();
}

class _CreateInforScreenState extends State<CreateInforScreen> {
  File _image;
  final picker = ImagePicker();
  List<Object> images = List<Object>();

  Future getImageAsCamera(int index) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      Navigator.pop(context);
      await getFileImage(index);
    } else {
      print('No image selected.');
    }
  }

  Future getImageInGallery(int index) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      Navigator.pop(context);
      await getFileImage(index);
    } else {
      print('No image selected.');
    }
  }

  checkPermissionOpenCamera(int index) async {
    if (await Permission.camera.request().isGranted) {
      getImageAsCamera(index);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(AppLocalizations.of(context).allowCamera),
          content: Text(AppLocalizations.of(context).explainAlowCamera),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                AppLocalizations.of(context).refuse,
                style:
                    TextStyle(fontFamily: 'Montserrat-M', color: Colors.black),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              child: Text(AppLocalizations.of(context).allow),
              onPressed: () => openAppSettings(),
            ),
          ],
        ),
      );
    }
  }

  checkPermissionOpenGallery(int index) async {
    if (await Permission.photos.request().isGranted) {
      getImageInGallery(index);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text(AppLocalizations.of(context).allowMemory),
                content: Text(AppLocalizations.of(context).explainAllowCamera),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      AppLocalizations.of(context).refuse,
                      style: TextStyle(
                          fontFamily: 'Montserrat-M', color: Colors.black),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: Text(AppLocalizations.of(context).allow),
                    onPressed: () => openAppSettings(),
                  ),
                ],
              ));
    }
  }

  final createFileBloc = CreateFileBloc();
  final bloc = ConfirmBloc();
  final TextEditingController _history = TextEditingController();
  final TextEditingController _note = TextEditingController();
  ContactModel _contact = ContactModel();

  @override
  void initState() {
    _contact = this.widget.contact;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context);
    return Scaffold(
        backgroundColor: AppColor.whitetwo,
        // appBar: AppBar(
        //   title: Text('Cập nhật thông tin',
        //       style:TextStyle(
        //           fontFamily: 'Montserrat-M',fontSize: 18, color: Colors.white)),
        //   centerTitle: true,
        //   leading: IconButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: Icon(Icons.arrow_back_ios),
        //   ),
        //   backgroundColor: AppColor.orangeColorDeep,
        // ),
        appBar: const TopAppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomAppBar(
                title: language.updateInformation,
                titleSize: 18,
              ),
              _buildTextTitle(language.note),
              _buildTextField(language.note, controller: _note),
              _buildTextTitle(language.symptoms),
              _buildTextField('${language.symptoms}...', controller: _history),
              _buildTextTitle(language.uploadRelatedImages),
              buildGridView(),
              SizedBox(
                height: 120,
              ),
            ],
          ),
        ),
        floatingActionButton:
            BlocProvider<CreateFileEvent, CreateFileState, CreateFileBloc>(
                bloc: createFileBloc,
                builder: (state) {
                  return Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(left: 50, right: 20),
                    child: CustomButton(
                      text: language.continues,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConfirmInforScreen(
                                servicePackageId: widget.servicePackageId,
                                timeSelect: widget.timeSelect ?? "",
                                useBookingTime: widget.useBookingTime,
                                dateTime: widget.dateTime,
                                history: _history.text,
                                staffName: this.widget.staffName,
                                address: this.widget.address,
                                note: _note.text,
                                staffId: widget.staffId,
                                images: images,
                                patientId: this.widget.patientId == null
                                    ? 0123
                                    : this.widget?.patientId,
                                contact: _contact,
                                branchId: widget.branchId),
                          ),
                        );
                      },
                      radius: BorderRadius.circular(26),
                      color: AppColor.purple,
                      style: TextStyle(
                          fontFamily: 'Montserrat-M', color: AppColor.white),
                    ),
                  );
                }));
  }

  Future _showAlert(BuildContext context, String message, int index) async {
    return showDialog(
        context: context,
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: _customDialog(context, index),
        ));
  }

  _customDialog(BuildContext context, int index) => Container(
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
                      onPressed: () {
                        checkPermissionOpenCamera(index);
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.image,
                        color: AppColor.deepBlue,
                        size: 60,
                      ),
                      onPressed: () {
                        checkPermissionOpenGallery(index);
                      }),
                ],
              ),
            ),
          ],
        ),
      );

  Widget buildGridView() {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var useMobileLayout = shortestSide < 600;
    var count = images.length + 1;
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(count, (index) {
        if (index == count - 1) {
          return InkWell(
            onTap: () => _showAlert(context, 'massage', index),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: roundStrokeCap,
            ),
          );
        } else {
          ImageUploadModel uploadModel = images[index];
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              children: <Widget>[
                useMobileLayout
                    ? Image.file(
                        uploadModel.imageFile,
                        width: 200,
                        height: 200,
                      )
                    : Image.file(
                        uploadModel.imageFile,
                        // width:200,
                        // height: 200,
                      ),
                Positioned(
                  right: useMobileLayout ? 0 : 35,
                  top: 0,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: useMobileLayout ? 20 : 40,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        images.remove(images[index]);
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  Future getFileImage(int index) async {
    setState(() {
      ImageUploadModel imageUpload = new ImageUploadModel();
      imageUpload.isUploaded = false;
      imageUpload.uploading = false;
      imageUpload.imageFile = _image;
      imageUpload.imageUrl = '';
      if (images.length == index) {
        images.add(imageUpload);
      } else {
        images[index] = imageUpload;
      }
    });
  }

  Widget get roundStrokeCap {
    return DottedBorder(
      dashPattern: [8, 4],
      strokeWidth: 2,
      color: AppColor.veryLightPinkTwo,
      strokeCap: StrokeCap.round,
      borderType: BorderType.RRect,
      radius: Radius.circular(5),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.8),
          child: Image.asset(
            'assets/images/ic_add.png',
            // height: 70,
            // width: 70,
          ),
        ),
      ),
    );
  }
}

_buildTextTitle(String text) {
  return Container(
      padding: const EdgeInsets.only(top: 18, left: 21),
      child: Text(
        text,
        style: TextStyle(
            fontFamily: 'Montserrat-M',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.darkPurple),
      ));
}

_buildTextField(
  String hintText, {
  Function(String) onChanged,
  TextEditingController controller,
}) {
  return Container(
    padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
    child: Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(8),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 15,
        //     offset: Offset(0, 0),
        //   ),
        // ]
      ),
      height: 135,
      padding: EdgeInsets.only(left: 13),
      child: CustomTextField(
        maxLine: 5,
        hintText: hintText,
        onChanged: onChanged,
        controller: controller,
      ),
    ),
  );
}
