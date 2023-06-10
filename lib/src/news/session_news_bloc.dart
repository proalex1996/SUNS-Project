import 'package:suns_med/shared/bloc_base.dart';

import 'package:suns_med/shared/service_proxy/management_portal_new/news/dto/comment_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/news/dto/postnews_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/news/dto/result_comment_model.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal/news/dto/news_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/user_rating_model.dart';

class NewsState {
  Map<int, PagingResult<PostNewsModel>> packageResultPost;
  PagingResult<ResultCommentModel> resultComment;
  PagingResult<PostNewsModel> resultAllNews;
  List<UserRatingModel> listUserRating;
  bool hasLike;
  bool allowedPost;
  String comment;
  bool deleteComment;
  NewsState({
    this.packageResultPost,
    this.hasLike,
    this.resultComment,
    this.comment,
    this.allowedPost,
    this.deleteComment,
  });
}

class LoadMoreEvent extends NewsEvent {
  int type;

  LoadMoreEvent({this.type});
}

class LoadEvent extends NewsEvent {
  int type;

  LoadEvent({this.type});
}

class LoadHasLikeEvent extends NewsEvent {
  String id;
  LoadHasLikeEvent({this.id});
}

class LikeEvent extends NewsEvent {
  String id;
  int type;
  LikeEvent({this.id, this.type});
}

class UnLikeEvent extends NewsEvent {
  String id;
  int type;
  UnLikeEvent({this.id, this.type});
}

class DeleteCommentEvent extends NewsEvent {
  String commentId;
  int userId;
  String newsId;
  DeleteCommentEvent({this.commentId, this.userId, this.newsId});
}

class ViewEvent extends NewsEvent {
  String id;
  int type;
  ViewEvent({this.id, this.type});
}

class GetAllNewsEvent extends NewsEvent {
  GetAllNewsEvent();
}

class ShareEvent extends NewsEvent {
  String id;
  int type;
  ShareEvent({this.id, this.type});
}

class CommentEvent extends NewsEvent {
  String id;
  CommentModel commentModel;
  CommentEvent({this.id, this.commentModel});
}

class LoadComment extends NewsEvent {
  String id;

  LoadComment({this.id});
}

abstract class NewsEvent {}

class NewsBloc extends BlocBase<NewsEvent, NewsState> {
  static final NewsBloc _instance = NewsBloc._internal();
  NewsBloc._internal();

  factory NewsBloc() {
    return _instance;
  }
  @override
  void initState() {
    this.state = new NewsState();
    this.state.packageResultPost = Map<int, PagingResult<PostNewsModel>>();

    // this.useGlobalLoading = false;
    super.initState();
  }

  @override
  Future<NewsState> mapEventToState(NewsEvent event) async {
    if (event is LoadMoreEvent) {
      var current = this.state.packageResultPost[event.type];
      await _addMoreDataN(current, event.type);
    } else if (event is LoadEvent) {
      // await _load(event.type);
      await _getPostNewsByType(event.type);
      await _getAllowedPost();
    } else if (event is ViewEvent) {
      // var hasLike = _getHasLikePost(event.id);
      // var view = _viewPost(event.id, event.type);
      // var comment = _getResultComment(event.id);
      // Future.wait([hasLike, view, comment]);
      await _getHasLikePost(event.id);
      await _viewPost(event.id, event.type);
      await _getResultComment(event.id);
    } else if (event is LikeEvent) {
      await _likePost(event.id, event.type);
      await _getPostNewsByType(event.type);
    } else if (event is UnLikeEvent) {
      await _unlikePost(event.id, event.type);
      await _getPostNewsByType(event.type);
    } else if (event is DeleteCommentEvent) {
      await _deleteComment(event.commentId, event.userId);
      await _getResultComment(event.newsId);
    } else if (event is ShareEvent) {
      await _sharePost(event.id, event.type);
      await _getPostNewsByType(event.type);
    } else if (event is LoadHasLikeEvent) {
      await _getHasLikePost(event.id);
    } else if (event is CommentEvent) {
      await _commentPost(event.id, event.commentModel);

      await _getResultComment(event.id);
    } else if (event is LoadComment) {
      await _getResultComment(event.id);
    } else if (event is GetAllNewsEvent) {
      await _getAllNews();
    }

    return this.state;
  }

  Future _getPostNewsByType(int id) async {
    var current = this.state.packageResultPost[id];
    if (current == null) {
      current = PagingResult<PostNewsModel>();
      this.state.packageResultPost[id] = current;
    } else {
      current.data = null;
      current.pageNumber = 1;
    }
    final serviceProxy = ServiceProxy().postNewsServiceProxy;
    var result = await serviceProxy.getPostnews(
        id, current.pageNumber = 1, current.pageSize = 10);
    this.state.packageResultPost[id] = result;
  }

  Future _getAllNews() async {
    var current = this.state.resultAllNews;
    if (current == null) {
      current = PagingResult<PostNewsModel>();
      this.state.resultAllNews = current;
    } else {
      current.data = null;
      current.pageNumber = 1;
    }
    final serviceProxy = ServiceProxy().postNewsServiceProxy;
    var result = await serviceProxy.getAllNews(
        current.pageNumber = 1, current.pageSize = 10);
    this.state.resultAllNews = result;
  }

  Future _addMoreDataN(PagingResult<PostNewsModel> model, int type) async {
    final service = ServiceProxy().postNewsServiceProxy;
    var result =
        await service.getPostnews(type, ++model.pageNumber, model.pageSize);
    if (model.data == null) {
      model.data = result.data;
    } else if (result != null) {
      model.data.addAll(result.data);
    }
  }

  Future _likePost(String postId, int id) async {
    final service = ServiceProxy().postNewsServiceProxy;
    await service.likePost(postId);
    this.state.hasLike = await service.getHasLikeOfPost(postId);

    // this.state.packageResultPost

    // var current = this.state.packageResultPost[id];
    // if (current == null) {
    //   current = PagingResult<PostNewsModel>();
    //   this.state.packageResultPost[id] = current;
    // } else {
    //   current.data = null;
    //   current.pageNumber = 1;
    // }
    // var result = await service.getPostnews(
    //     id, current.pageNumber = 1, current.pageSize = 10);
    // this.state.packageResultPost[id] = result;
  }

  Future _unlikePost(String postId, int id) async {
    final service = ServiceProxy().postNewsServiceProxy;
    await service.unlikePost(postId);
    this.state.hasLike = await service.getHasLikeOfPost(postId);

    // var current = this.state.packageResultPost[id];
    // if (current == null) {
    //   current = PagingResult<PostNewsModel>();
    //   this.state.packageResultPost[id] = current;
    // } else {
    //   current.data = null;
    //   current.pageNumber = 1;
    // }
    // var result = await service.getPostnews(
    //     id, current.pageNumber = 1, current.pageSize = 10);
    // this.state.packageResultPost[id] = result;
  }

  Future _deleteComment(String commentId, int userId) async {
    final service = ServiceProxy();
    await service.newsCommentServiceProxy.deleteComment(commentId);
  }

  Future _viewPost(postId, int id) async {
    final service = ServiceProxy().postNewsServiceProxy;
    await service.viewPost(postId);

    var current = this.state.packageResultPost[id];
    if (current == null) {
      current = PagingResult<PostNewsModel>();
      this.state.packageResultPost[id] = current;
    } else {
      current.data = null;
      current.pageNumber = 1;
    }
    var result = await service.getPostnews(
        id, current.pageNumber = 1, current.pageSize = 10);
    this.state.packageResultPost[id] = result;
  }

  Future _sharePost(postId, int id) async {
    final service = ServiceProxy().postNewsServiceProxy;
    await service.sharePost(postId);

    var current = this.state.packageResultPost[id];
    if (current == null) {
      current = PagingResult<PostNewsModel>();
      this.state.packageResultPost[id] = current;
    } else {
      current.data = null;
      current.pageNumber = 1;
    }
    var result = await service.getPostnews(
        id, current.pageNumber = 1, current.pageSize = 10);
    this.state.packageResultPost[id] = result;
  }

  Future _getHasLikePost(String id) async {
    final service = ServiceProxy().postNewsServiceProxy;
    this.state.hasLike = await service.getHasLikeOfPost(id);
  }

  Future _commentPost(String id, CommentModel commentModel) async {
    final service = ServiceProxy().postNewsServiceProxy;
    this.state.comment = await service.commentPost(id, commentModel);
  }

  Future _getResultComment(String id) async {
    var current = this.state.resultComment;
    if (current == null) {
      current = PagingResult<ResultCommentModel>();
      this.state.resultComment = current;
    } else {
      current.data = null;
      current.pageNumber = 1;
    }
    final serviceProxy = ServiceProxy();
    var result = await serviceProxy.postNewsServiceProxy
        .resultComment(id, current.pageNumber = 1, current.pageSize = 10);
    this.state.resultComment = result;
    if (result.data != null && result.data.isNotEmpty) {
      this.state.listUserRating = await serviceProxy.userService
          .getUserRating(result.data.map((e) => e.createdById).toList());
    }

    // if (result?.data != null && result.data.length > 0) {
    //   this.state.listUserRating = await serviceProxy.userService
    //       .getUserRating(result.data.map((e) => e.createdById).toList());
    // }
  }

  // Future _addMoreComment(
  //     PagingResult<ResultCommentModel> model, String id) async {
  //   final service = ServiceProxy().postNewsServiceProxy;
  //   var result =
  //       await service.resultComment(id, ++model.pageNumber, model.pageSize);
  //   if (model.data == null) {
  //     model.data = result.data;
  //   } else if (result != null) {
  //     model.data.addAll(result.data);
  //   }
  // }
  Future _getAllowedPost() async {
    final service = ServiceProxy().postNewsServiceProxy;
    this.state.allowedPost = await service.allowedPost();
  }
}
