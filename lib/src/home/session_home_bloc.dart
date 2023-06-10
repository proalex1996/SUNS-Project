import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/service_package_company_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/news/dto/postnews_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';

class HomeState {
  List<ServicePackageOfCompanyModel> servicePackageOfCompany;
  List<PostNewsModel> listPost;
  List<PostNewsModel> listPromotionPost;
  HomeState({this.servicePackageOfCompany, this.listPost});
  PagingResult<ServicePackageOfCompanyModel> popularServicePackagePaging;
}

abstract class HomeEvent {}

class EventLoadPopularServicePackage extends HomeEvent {}

class EventLoadPromotionPost extends HomeEvent {}

class EventLoadAllPopularService extends HomeEvent {}

class EventLoadMorePopularService extends HomeEvent {}

class HomeBloc extends BlocBase<HomeEvent, HomeState> {
  static final HomeBloc _singleton = HomeBloc._internal();

  factory HomeBloc() {
    return _singleton;
  }

  HomeBloc._internal();
  @override
  void initState() {
    this.state = HomeState();
    super.initState();
  }

  @override
  Future<HomeState> mapEventToState(HomeEvent event) async {
    if (event is EventLoadPopularServicePackage) {
      var _getServicePackagePopular = _getServicePopular();
      var _getPostNew = _getPostNews();
      await Future.wait([_getServicePackagePopular, _getPostNew]);
    } else if (event is EventLoadMorePopularService) {
      var current = this.state.popularServicePackagePaging;
      await _addMorePopularService(current);
    } else if (event is EventLoadAllPopularService) {
      await _getAllServicePackage();
    } else if (event is EventLoadPromotionPost) {
      await _getPromotionNews();
    }
    return this.state;
  }

  Future _getServicePopular() async {
    final service = ServiceProxy();
    var res =
        await service.doctorCheckServiceProxy.getServicePackagePopular(1, 5);
    this.state.servicePackageOfCompany = res.data;
  }

  Future _getAllServicePackage() async {
    final service = ServiceProxy();
    var current = this.state.popularServicePackagePaging;
    if (current == null) {
      current = PagingResult<ServicePackageOfCompanyModel>();
      this.state.popularServicePackagePaging = current;
    } else {
      current.data = null;
      current.pageNumber = 1;
    }

    var res = await service.doctorCheckServiceProxy.getServicePackagePopular(
        current.pageNumber = 1, current.pageSize = 10);
    this.state.popularServicePackagePaging = res;
  }

  Future _addMorePopularService(
      PagingResult<ServicePackageOfCompanyModel> model) async {
    final service = ServiceProxy().doctorCheckServiceProxy;
    var result = await service.getServicePackagePopular(
        ++model.pageNumber, model.pageSize);
    if (model.data == null) {
      model.data = result.data;
    } else if (result != null) {
      model.data.addAll(result.data);
    }
  }

  Future _getPostNews() async {
    final serviceProxy = ServiceProxy().postNewsServiceProxy;
    var result = await serviceProxy.getSearchPostPopular(null, 1, 5);
    this.state.listPost = result?.data;
  }

  Future _getPromotionNews() async {
    final serviceProxy = ServiceProxy().postNewsServiceProxy;
    var result = await serviceProxy.getPostnews(4, 1, 5);
    this.state.listPromotionPost = result?.data;
  }
}
