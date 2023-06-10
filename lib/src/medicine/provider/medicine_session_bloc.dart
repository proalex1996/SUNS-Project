import 'package:suns_med/shared/bloc_base.dart';

import 'package:suns_med/shared/service_proxy/management_portal_new/news/dto/comment_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/news/dto/postnews_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/news/dto/result_comment_model.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/src/medicine/dto/detail_order_model.dart';
import 'package:suns_med/src/medicine/dto/medicine_model.dart';
import 'package:suns_med/src/medicine/dto/detail_medicine.dart';
import 'package:suns_med/src/medicine/dto/adress_shipping_model.dart';
import 'package:suns_med/src/medicine/dto/order_model.dart';

import 'package:suns_med/src/medicine/dto/place_order_model.dart';

class MedicineState {
  PagingResult<MedicineModel> packageResultMedicine;
  PagingResult<OrderModel> packageResultOrder;
  PagingResult<UserAddressModel> packageResultUserAddress;
  DetailMedicineModel resultDetailMedicine;
  DetailOrderModel resultDetailOrder;
  String resultAdress;
  MedicineState(
      {this.packageResultMedicine,
      this.resultDetailMedicine,
      this.resultAdress,
      this.resultDetailOrder,
      this.packageResultOrder,
      this.packageResultUserAddress});
}

class LoadMoreEvent extends MedicineEvent {
  LoadMoreEvent();
}

class LoadEvent extends MedicineEvent {
  LoadEvent();
}

class LoadAddressEvent extends MedicineEvent {
  LoadAddressEvent();
}

class SearchEvent extends MedicineEvent {
  String key;
  SearchEvent({this.key});
}

class ViewEvent extends MedicineEvent {
  String id;
  ViewEvent({this.id});
}

class GetDetailOrderEvent extends MedicineEvent {
  String id;
  GetDetailOrderEvent({this.id});
}

class CompletedEvent extends MedicineEvent {
  AdressModel adressModel;
  CompletedEvent({
    this.adressModel,
  });
}

class OrderEvent extends MedicineEvent {
  PlaceOrdersModel orderModel;
  OrderEvent({
    this.orderModel,
  });
}

class GetOrderEvent extends MedicineEvent {
  GetOrderEvent();
}

class CommentEvent extends MedicineEvent {
  String id;
  CommentModel commentModel;
  CommentEvent({this.id, this.commentModel});
}

class LoadComment extends MedicineEvent {
  String id;
  LoadComment({this.id});
}

abstract class MedicineEvent {}

class MedicineBloc extends BlocBase<MedicineEvent, MedicineState> {
  static final MedicineBloc _instance = MedicineBloc._internal();
  MedicineBloc._internal();

  factory MedicineBloc() {
    return _instance;
  }
  @override
  void initState() {
    this.state = new MedicineState();
    this.state.packageResultMedicine = PagingResult<MedicineModel>();
    this.state.packageResultUserAddress = PagingResult<UserAddressModel>();
    this.state.resultDetailMedicine = DetailMedicineModel();
    this.state.resultDetailOrder = DetailOrderModel();
    this.state.packageResultOrder = PagingResult<OrderModel>();

    // this.useGlobalLoading = false;
    super.initState();
  }

  @override
  Future<MedicineState> mapEventToState(MedicineEvent event) async {
    if (event is LoadMoreEvent) {
    } else if (event is LoadEvent) {
      var _current = state.packageResultMedicine;
      await _getMedicine(_current);
    } else if (event is SearchEvent) {
      await _getSearchMedicine(event.key);
    } else if (event is ViewEvent) {
      await _getDetailMedicine(event.id);
    } else if (event is CompletedEvent) {
      await _setAdressShipping(event.adressModel);
    } else if (event is LoadAddressEvent) {
      await _getAdressShipping();
    } else if (event is OrderEvent) {
      await _setOrder(event.orderModel);
    } else if (event is GetOrderEvent) {
      var _current = state.packageResultOrder;
      await _getOrder(_current);
    } else if (event is GetDetailOrderEvent) {
      await _getDetailOrder(event.id);
    }

    return this.state;
  }

  Future _getMedicine(PagingResult<MedicineModel> model) async {
    model.pageNumber = 0;
    model.pageSize = 20;
    final service = ServiceProxy().medicineSeviceProxy;
    final result =
        await service.getMedicine(++model.pageNumber, model.pageSize);
    if (model.data == null) {
      model.data = result.data;
      this.state.packageResultMedicine.data = model.data;
    } else {
      model.data.clear();
      model.data.addAll(result.data);
      this.state.packageResultMedicine.data = model.data;
    }
  }

  Future _getAdressShipping() async {
    final service = ServiceProxy().medicineSeviceProxy;
    this.state.packageResultUserAddress = await service.getAdressShipping();
  }

  Future _getSearchMedicine(String key) async {
    final service = ServiceProxy().medicineSeviceProxy;
    this.state.packageResultMedicine =
        await service.getSearchMedicine(1, 1000, key);
  }

  Future _getDetailMedicine(String id) async {
    final service = ServiceProxy().medicineSeviceProxy;
    this.state.resultDetailMedicine = await service.getDetailMedicine(id);
  }

  Future _getOrder(PagingResult<OrderModel> model) async {
    model.pageNumber = 0;
    model.pageSize = 20;
    final service = ServiceProxy().medicineSeviceProxy;
    final result = await service.getOrder(++model.pageNumber, model.pageSize);
    if (model.data == null) {
      model.data = result.data;
      this.state.packageResultOrder.data = model.data;
    } else {
      model.data.clear();
      model.data.addAll(result.data);
      this.state.packageResultOrder.data = model.data;
    }
  }

  Future _setAdressShipping(AdressModel adressModel) async {
    final service = ServiceProxy().medicineSeviceProxy;
    this.state.resultAdress = await service.setAdressShipping(adressModel);
  }

  Future _setOrder(PlaceOrdersModel order) async {
    final service = ServiceProxy().medicineSeviceProxy;
    this.state.resultAdress = await service.setOrder(order);
  }

  Future _getDetailOrder(String id) async {
    final service = ServiceProxy().medicineSeviceProxy;
    this.state.resultDetailOrder = await service.getDetailOrder(id);
  }
}
