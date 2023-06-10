import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/log_portal/payment/dto/user_wallet_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/like/dto/like_company.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/news/dto/postnews_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class AccountState {
  UserWalletMode userWallet;
  List<LikeCompanyModel> likeCompany;
  List<PostNewsModel> likeNews;
  AccountState({this.userWallet, this.likeCompany, this.likeNews});
}

abstract class AccountEvent {}

class LoadWalletEvent extends AccountEvent {}

class LoadFavoriteEvent extends AccountEvent {}

class LoadFavoriteNewsEvent extends AccountEvent {
  String user;
  LoadFavoriteNewsEvent({this.user});
}

class LoadLikeCompany extends AccountEvent {}

class LoadLikeNews extends AccountEvent {}

class AccountBloc extends BlocBase<AccountEvent, AccountState> {
  @override
  void initState() {
    this.state = new AccountState();
    super.initState();
  }

  @override
  Future<AccountState> mapEventToState(AccountEvent event) async {
    if (event is LoadWalletEvent) {
      await _getUserWallet();
    } else if (event is LoadLikeCompany) {
      await _loadLikeCompany();
    } else if (event is LoadLikeNews) {
      await _loadLikeNews();
    }
    return this.state;
  }

  Future _getUserWallet() async {
    final service = ServiceProxy().paymentServiceProxy;
    this.state.userWallet = await service.getUserWallet();
  }

  Future _loadLikeCompany() async {
    final service = ServiceProxy().likeServiceProxy;
    var res = await service.getLikeCompany();
    this.state.likeCompany = res?.data;
  }

  Future _loadLikeNews() async {
    final service = ServiceProxy().likeServiceProxy;
    var res = await service.getLikeNews();
    this.state.likeNews = res?.data;
  }
}
