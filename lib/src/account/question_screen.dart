import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/feedback_model.dart';
import 'package:suns_med/src/Widgets/button.dart';
import 'package:suns_med/src/account/session_question_bloc.dart';

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  // final TextEditingController _titleController = TextEditingController();
  // final TextEditingController _contentController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  final bloc = QuestionBloc();
  FeedbackModel _feedback = new FeedbackModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColor.whitethree,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.deepBlue,
        title: Text(
          'Góp ý - câu hỏi',
          style: TextStyle(
              fontFamily: 'Montserrat-M', color: Colors.white, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 21),
            child: Icon(
              Icons.search,
              size: 25,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 20, left: 16, right: 18),
          child: Form(
            key: globalFormKey,
            child: BlocProvider<QuestionEvent, QuestionState, QuestionBloc>(
              bloc: bloc,
              builder: (output) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hotline',
                      style:
                          TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                    ),
                    SizedBox(
                      height: 9,
                    ),
                    Text(
                      '1900 2805',
                      style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 23,
                    ),
                    Text(
                      'Tiêu đề',
                      style:
                          TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 15,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white),
                      padding: const EdgeInsets.only(left: 13),
                      child: TextFormField(
                        onChanged: (t) {
                          _feedback.title = t;
                        },
                        validator: (input) =>
                            input.length == null || input.isEmpty
                                ? "Không được bỏ trống tiêu đề"
                                : null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontFamily: 'Montserrat-M',
                              fontSize: 16,
                              color: AppColor.lavender),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 21,
                    ),
                    Text(
                      'Nội dung',
                      style:
                          TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 15,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white),
                      padding: const EdgeInsets.only(left: 13),
                      child: TextFormField(
                        onChanged: (t) {
                          _feedback.content = t;
                        },
                        validator: (input) =>
                            input.length == null || input.isEmpty
                                ? "Không được bỏ trống nội dung"
                                : null,
                        maxLines: 6,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontFamily: 'Montserrat-M',
                              fontSize: 16,
                              color: AppColor.lavender),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(top: 23, left: 15, right: 15),
                      child: CustomButton(
                        color: AppColor.deepBlue,
                        onPressed: () {
                          final form = globalFormKey.currentState;
                          if (form.validate()) {
                            form.save();
                            bloc.dispatch(
                              CreateQuestionEvent(
                                  title: _feedback.title,
                                  content: _feedback.content),
                            );
                            scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text('Gửi góp ý thành công'),
                              ),
                            );
                            Navigator.of(context).pop(true);
                          }
                        },
                        radius: BorderRadius.circular(26),
                        text: 'Gửi',
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
