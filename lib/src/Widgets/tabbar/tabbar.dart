import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/tabbar/session_getlisttab_bloc.dart';
import 'package:suns_med/src/news/tabbar/home_news/general_post_screen.dart';
import 'package:suns_med/src/news/tabbar/medical_news.dart';

class CustomTabbar extends StatefulWidget {
  @override
  _CustomTabbarState createState() => _CustomTabbarState();
}

class _CustomTabbarState extends State<CustomTabbar> {
  final bloc = TabbarBloc();

  @override
  void initState() {
    if (bloc.state.listCategory == null) {
      bloc.dispatch(GetListNameTabEvent());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TabbarEvent, TabbarState, TabbarBloc>(
      bloc: bloc,
      builder: (state) {
        var length = state.listCategory?.length ?? 0;
        return DefaultTabController(
          length: length,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: AppBar(
                backgroundColor: AppColor.veryLightPinkFour,
                bottom: TabBar(
                  labelColor: AppColor.pumpkin,
                  unselectedLabelColor: AppColor.deepBlue,
                  tabs: state.listCategory
                          ?.map(
                            (e) => (Tab(
                              text: e.name,
                            )),
                          )
                          ?.toList() ??
                      [],
                  isScrollable: true,
                  indicatorColor: AppColor.pumpkin,
                ),
              ),
            ),
            body: state.listCategory == null
                ? Container()
                : TabBarView(
                    children: List.generate(length, (index) {
                      {
                        var item = state.listCategory[index];
                        if (item.id == 1) {
                          return GeneralPostsScreen(
                            categoryId: item.id,
                          );
                        }
                        return MedicalNewScreen(
                          categoryId: item.id,
                        );
                      }
                    }),
                  ),
          ),
        );
      },
    );
  }
}
