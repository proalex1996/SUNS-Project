import 'dart:convert';
import 'dart:io';
import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal/news/dto/create_post_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/category/dto/input_post_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class PostState {
  bool isCreated;
  PostState({this.isCreated = false});
}

abstract class PostEvent {}

class CreatePostEvent extends PostEvent {
  CreatePostModel createPostModel;
  InputPostModel inputPostModel;
  File image;
  int categoryId;
  CreatePostEvent(
      {this.image, this.createPostModel, this.inputPostModel, this.categoryId});
}

class PostBloc extends BlocBase<PostEvent, PostState> {
  // static final PostBloc _instance = PostBloc._internal();
  // PostBloc._internal();
  // // CreatePostModel _createPost = CreatePostModel();

  // factory PostBloc() {
  //   return _instance;
  // }
  InputPostModel _inputPostModel = InputPostModel();
  @override
  void initState() {
    this.state = new PostState();
    this.state.isCreated = false;

    super.initState();
  }

  @override
  Future<PostState> mapEventToState(PostEvent event) async {
    if (event is CreatePostEvent) {
      // await _createNewPost(event.image, event.createPostModel);
      await _createPostNews(
          event.image, event.inputPostModel, event.categoryId);
      this.state.isCreated = true;
    }
    return this.state;
  }

  Future _createPostNews(
      File _image, InputPostModel inputPost, int categoryId) async {
    final service = ServiceProxy().categoryServiceProxy;
    _inputPostModel = inputPost;
    _inputPostModel.shortDescription = inputPost.name;
    var imageBytes = await _image?.readAsBytes();
    _inputPostModel.imageFile =
        imageBytes != null ? base64Encode(imageBytes) : null;
    await service.createPost(_inputPostModel, categoryId);
  }

  // Future _createNewPost(File _image, CreatePostModel createPostModel) async {
  //   final service = ServiceProxy();
  //   _createPost = createPostModel;
  //   var imageBytes = await _image?.readAsBytes();
  //   _createPost.avatar = imageBytes != null ? base64Encode(imageBytes) : null;
  //   await service.newsServiceProxy.createPost(_createPost);
  //   // Navigator.pop(context);
  // }
}
