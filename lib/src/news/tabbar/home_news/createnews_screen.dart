import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/category/dto/category_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/category/dto/input_post_model.dart';
import 'package:suns_med/src/Widgets/tabbar/session_getlisttab_bloc.dart';
import 'package:suns_med/src/news/session_news_bloc.dart';
import 'package:suns_med/src/news/tabbar/home_news/session_createpost_bloc.dart';

class CreateNewsScreen extends StatefulWidget {
  final int categoryId;
  CreateNewsScreen({this.categoryId});
  @override
  _CreateNewsScreenState createState() => _CreateNewsScreenState();
}

class _CreateNewsScreenState extends State<CreateNewsScreen> {
  final picker = ImagePicker();
  File _image;
  Future getImageAsCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    _setImage(pickedFile);
    setState(() {});
  }

  Future getImageAsGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    _setImage(pickedFile);
  }

  _setImage(PickedFile pickedFile) {
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        Navigator.pop(context);
      });
    } else {
      print('No image selected.');
    }
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  final tabbarbloc = TabbarBloc();

  final bloc = PostBloc();

  final newsBloc = NewsBloc();

  InputPostModel _inputPost = InputPostModel();

  bool isVali = false;

  int categoryId;

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    if (tabbarbloc.state.listCategory == null) {
      tabbarbloc.dispatch(GetListNameTabEvent());
    }
    categoryId = widget.categoryId;
    super.initState();
  }

  String dropdownValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColor.whitetwo,
      appBar: AppBar(
        title: Text('Viết bài',
            style: TextStyle(
                fontFamily: 'Montserrat-M', fontSize: 18, color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColor.deepBlue,
        actions: <Widget>[
          BlocProvider<PostEvent, PostState, PostBloc>(
              bloc: bloc,
              navigator: (state) {
                if (state.isCreated == true) Navigator.of(context).pop();
              },
              builder: (state) {
                return Container(
                  alignment: Alignment.center,
                  child: MaterialButton(
                    onPressed: () {
                      // _title.text.isEmpty ? isVali = true : isVali = false;
                      final form = globalFormKey.currentState;
                      if (form.validate()) {
                        form.save();
                        bloc.dispatch(
                          CreatePostEvent(
                            image: _image,
                            // createPostModel: _createPost,
                            inputPostModel: _inputPost,
                            categoryId: categoryId,
                          ),
                        );
                        newsBloc.dispatch(LoadEvent(type: categoryId));
                      }
                    },
                    child: Text(
                      'Đăng',
                      style: TextStyle(
                          fontFamily: 'Montserrat-M', color: Colors.white),
                    ),
                  ),
                );
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: globalFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextTitle('Chuyên khoa, chủ đề'),
              _dropDownMenu(),
              _buildTextTitle('Tên bài viết'),
              _buildTextField(
                'Nhập tên bài viết',
                maxLine: 3,
                validator: (input) => input.isEmpty || input.length == 0
                    ? "Vui lòng nhập thông tin này"
                    : null,
                onChanged: (t) {
                  _inputPost.name = t;
                },
                // controller: _title,
                // validate: isVali ? 'Không được để trống tiêu đề' : null,
              ),
              _buildTextTitle('Ảnh chủ đề'),
              _buildToolAddImage(),
              _buildTextTitle('Nội dung bài viết'),
              _buildTextField(
                'Nhập nội dung...',
                maxLine: 10,
                validator: (t) =>
                    t.length < 3 ? "Vui lòng nhập thông tin này" : null,
                onChanged: (t) {
                  _inputPost.description = t;
                  // _inputPost.shortDescription = t.substring(0, 100);
                },
              ),
              SizedBox(
                height: 200,
              )
            ],
          ),
        ),
      ),
    );
  }

  _dropDownMenu() {
    return BlocProvider<TabbarEvent, TabbarState, TabbarBloc>(
      bloc: tabbarbloc,
      builder: (state) {
        return Container(
          width: 200,
          margin: const EdgeInsets.only(left: 20, top: 15),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: Offset(0, 0),
            ),
          ], borderRadius: BorderRadius.circular(6), color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.only(left: 13),
            child: DropdownButtonFormField<int>(
              value: categoryId,
              icon: Icon(
                Icons.arrow_drop_down,
                color: Color(0xffb7b7b7),
              ),
              validator: (value) => value == null ? 'Chưa chọn chủ đề' : null,
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
              // underline: Container(
              //   height: 0,
              //   color: Colors.deepPurpleAccent,
              // ),
              onChanged: (int newValue) {
                setState(() {
                  categoryId = newValue;
                });
              },
              hint: Text(
                'Chủ đề',
                style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: 16,
                    color: AppColor.lavender),
              ),
              items: state?.listCategory
                  ?.map<DropdownMenuItem<int>>((CategoryModel value) {
                return DropdownMenuItem<int>(
                  value: value.id,
                  child: Text(
                    value.name,
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 16,
                        color: Colors.black),
                  ),
                );
              })?.toList(),
            ),
          ),
        );
      },
    );
  }

  Future _showAlert(BuildContext context, String message) async {
    return showDialog(
        context: context,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: _customDialog(context),
        ));
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
                      onPressed: getImageAsCamera),
                  IconButton(
                      icon: Icon(
                        Icons.image,
                        color: AppColor.deepBlue,
                        size: 60,
                      ),
                      onPressed: getImageAsGallery)
                ],
              ),
            ),
          ],
        ),
      );

  _buildToolAddImage() {
    return GestureDetector(
      onTap: () => _showAlert(context, 'massage').then((t) {
        setState(() {});
      }),
      child: _image == null
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: roundStrokeCap,
            )
          : Stack(
              children: [
                Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(left: 20, top: 20),
                    child: Image.file(_image)),
                Positioned(
                  right: 5,
                  top: 10,
                  child: GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          _image = null;
                        },
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      minRadius: 10,
                      child: Icon(
                        Icons.close,
                        size: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Widget get roundStrokeCap {
    return DottedBorder(
      dashPattern: [8, 4],
      strokeWidth: 2,
      color: AppColor.veryLightPinkTwo,
      strokeCap: StrokeCap.round,
      borderType: BorderType.RRect,
      radius: Radius.circular(5),
      child: Container(
        height: 111,
        width: 111,
        padding: const EdgeInsets.all(42.8),
        child: Image.asset(
          'assets/images/ic_add.png',
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
            fontWeight: FontWeight.bold),
      ));
}

_buildTextField(
  String hintText, {
  int maxLine,
  Function(String) validator,
  Function(String) onChanged,
  TextEditingController controller,
}) {
  return Container(
    margin: EdgeInsets.all(20),
    padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
    decoration: BoxDecoration(boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 15,
        offset: Offset(0, 0),
      ),
    ], borderRadius: BorderRadius.circular(6), color: Colors.white),
    child: TextFormField(
      // key: globalFormKey,
      // keyboardType: type,
      controller: controller,
      onChanged: onChanged,
      // onSaved: (input) => loginModel.userName = input,
      validator: validator,
      maxLines: maxLine ?? 4,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    ),
    //  CustomTextField(
    //   maxLine: maxLine ?? 4,
    //   hintText: hintText,
    //   validator: validate,
    //   onChanged: onChanged,
    //   controller: controller,
    //   style:TextStyle(
    //             fontFamily: 'Montserrat-M',color: Colors.black),
    // ),
  );
}
