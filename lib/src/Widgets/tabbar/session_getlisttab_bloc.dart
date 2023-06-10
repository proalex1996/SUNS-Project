import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal/news/dto/tabbar_news_model.dart';

import 'package:suns_med/shared/service_proxy/management_portal_new/category/dto/category_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class TabbarState {
  // List<MenuNewsModel> listTabbarNews;
  List<MenuNewsModel> listTabbarNews;
  List<CategoryModel> listCategory;
  TabbarState({this.listTabbarNews, this.listCategory});
}

abstract class TabbarEvent {}

class GetListNameTabEvent extends TabbarEvent {}

class TabbarBloc extends BlocBase<TabbarEvent, TabbarState> {
  static final TabbarBloc _instance = TabbarBloc._internal();
  TabbarBloc._internal();

  factory TabbarBloc() {
    return _instance;
  }
  @override
  void initState() {
    this.state = new TabbarState();
    super.initState();
  }

  @override
  Future<TabbarState> mapEventToState(TabbarEvent event) async {
    if (event is GetListNameTabEvent) {
      // await _initTabbar();
      await _getCategory();
    }
    return this.state;
  }

  // Future _initTabbar() async {
  //   final service = ServiceProxy();
  //   this.state.listTabbarNews = await service.newsServiceProxy.getMenuNews();
  // }

  Future _getCategory() async {
    final service = ServiceProxy().categoryServiceProxy;
    this.state.listCategory = await service.getCategory();
  }

  // Future _initTabbar() async {
  //   final service = ServiceProxy();
  //   this.state.listTabbarNews = await service.postNewsServiceProxy.getMenuNews();
  // }
}
