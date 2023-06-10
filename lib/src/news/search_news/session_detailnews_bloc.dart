import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal/news/dto/news_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class DetailNewsState {
  NewsModel news;
  DetailNewsState({this.news});
}

abstract class DetailNewsEvent {}

class LoadDetailNewsEvent extends DetailNewsEvent {
  NewsModel newsModel;
  int id;
  String userName;
  LoadDetailNewsEvent({
    this.newsModel,
    this.id,
    this.userName,
  });
} 

class DetailNewsBloc extends BlocBase<DetailNewsEvent, DetailNewsState> {
  @override
  void initState() {
    this.state = new DetailNewsState();
    super.initState();
  }

  @override
  Future<DetailNewsState> mapEventToState(DetailNewsEvent event) async {
    if (event is LoadDetailNewsEvent) {
      await _detailNews(
        event.newsModel,
        event.id,
        event.userName,
      );
    }
    return this.state;
  }

  Future _detailNews(
    NewsModel newsModel,
    int id,
    String userName,
  ) async {
    final service = ServiceProxy().newsServiceProxy;
    this.state.news = await service.viewNews(
      newsModel,
      id,
      userName,
    );
  }
}
