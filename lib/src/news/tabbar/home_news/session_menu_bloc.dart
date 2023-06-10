import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal/news/dto/tabbar_news_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class MenuState {
  List<MenuNewsModel> listMenuNews;
}

abstract class MenuEvent {}

class GetMenuEvent extends MenuEvent {}

class MenuBloc extends BlocBase<MenuEvent, MenuState> {
  @override
  void initState() {
    this.state = new MenuState();
    super.initState();
  }

  @override
  Future<MenuState> mapEventToState(MenuEvent event) async {
    if (event is GetMenuEvent) {
      await _initMenu();
    }
    return this.state;
  }

  Future _initMenu() async {
    final service = ServiceProxy();
    this.state.listMenuNews = await service.newsServiceProxy.getMenuNews();
  }
}
