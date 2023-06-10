import 'package:flutter/material.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/session_detail_hospital_bloc.dart';
import 'package:suns_med/src/Widgets/special_item.dart';
import 'package:suns_med/src/home/session_department_bloc.dart';
import 'package:suns_med/src/special/listdoctor_screen.dart';
import 'package:suns_med/common/theme/theme_color.dart';

class SpecialScreen extends StatefulWidget {
  final CompanyType type;
  final String id;
  final String city;

  const SpecialScreen({Key key, this.type, this.id, this.city})
      : super(key: key);

  @override
  _SpecialScreenState createState() => _SpecialScreenState();
}

class _SpecialScreenState extends State<SpecialScreen> {
  final departmentSpecialBloc = DepartmentBloc();

  @override
  void initState() {
    departmentSpecialBloc.dispatch(LoadDepartmentEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.deepBlue,
        centerTitle: true,
        title: Text(
          'Chuyên khoa',
          style: TextStyle(
              fontFamily: 'Montserrat-M', color: Colors.white, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 21, top: 25, bottom: 11),
              alignment: Alignment.centerLeft,
              child: Text(
                'Tất cả chuyên khoa',
                style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
              ),
            ),
            BlocProvider<DepartmentEvent, DepartmentState, DepartmentBloc>(
              bloc: departmentSpecialBloc,
              builder: (output) {
                return Wrap(
                  // direction: Axis.horizontal,
                  // alignment: WrapAlignment.spaceAround,
                  // crossAxisAlignment: WrapCrossAlignment.start,
                  // runAlignment: WrapAlignment.end,
                  children: List.generate(
                    output.departmentNew?.length ?? 0,
                    (index) {
                      return Container(
                        width: 90,
                        child: SpecialItem(
                          title: output.departmentNew[index]?.name,
                          image: output.departmentNew[index]?.image,
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListSpecialScreen(
                                  departmentId: output.departmentNew[index].id,
                                  department: output.departmentNew[index]?.name,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
