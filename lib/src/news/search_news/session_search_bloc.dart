import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal/news/dto/news_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/news/dto/postnews_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class SearchState {
  List<NewsModel> listNews;
  SearchState({this.listNews});
  List<PostNewsModel> listPost;
}

abstract class SearchEvent {}

class ResultSreachEvent extends SearchEvent {
  String keyValue;
  ResultSreachEvent({this.keyValue});
}

class EventSearch extends SearchEvent {
  String keyword;

  EventSearch({this.keyword});
}

class SearchBloc extends BlocBase<SearchEvent, SearchState> {
  @override
  void initState() {
    this.state = new SearchState();
    super.initState();
  }

  @override
  Future<SearchState> mapEventToState(SearchEvent event) async {
    if (event is ResultSreachEvent) {
      await _getSearchKey(event.keyValue);
    } else if (event is EventSearch) {
      await _getSearchPostNews(event.keyword);
    }
    return this.state;
  }

  Future _getSearchKey(String value) async {
    final service = ServiceProxy();
    this.state.listNews = await service.newsServiceProxy.searchNews(value);
  }

  Future _getSearchPostNews(String keyword) async {
    final serviceProxy = ServiceProxy().postNewsServiceProxy;
    var result = await serviceProxy.getSearchPost(keyword, 1, 10);
    this.state.listPost = result?.data;
  }
}
