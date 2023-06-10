import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/doctor_hospital_clinic_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/service_package_company_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class SearchState {
  List<ListDHCModel> listSearch;
  List<ServicePackageOfCompanyModel> servicePackage;
  SearchState({this.listSearch, this.servicePackage});
}

abstract class SearchEvent {}

class EventInputKey extends SearchEvent {
  String keyword;

  EventInputKey({this.keyword});
}

class SearchBloc extends BlocBase<SearchEvent, SearchState> {
  @override
  void initState() {
    this.state = new SearchState();
    super.initState();
  }

  @override
  Future<SearchState> mapEventToState(SearchEvent event) async {
    if (event is EventInputKey) {
      await _searchService(event.keyword);
    }
    return this.state;
  }

  // Future _getListSearchCompany(String id, String keyword) async {
  //   final service = ServiceProxy().provinceServiceProxy;
  //   var res = await service.searchCompany(id, keyword);
  //   this.state.listSearch = res?.data;
  // }

  Future _searchService(String keyword) async {
    final service = ServiceProxy();
    var res =
        await service.doctorCheckServiceProxy.getServicePackage(keyword, 1, 10);
    this.state.servicePackage = res?.data;
  }
}
