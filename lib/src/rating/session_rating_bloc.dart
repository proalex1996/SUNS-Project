import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/rating_input.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class RatingState {
  bool checkEvent;
  bool isRated;
  RatingState({this.checkEvent = false, this.isRated});
}

abstract class RatingEvent {}

class EventPostRating extends RatingEvent {
  final RatingInput rateCommentModel;
  final String companyType, companyId;

  EventPostRating({this.rateCommentModel, this.companyType, this.companyId});
}

class RatingBloc extends BlocBase<RatingEvent, RatingState> {
  RatingInput _rateComment = RatingInput();

  @override
  void initState() {
    this.state = new RatingState();
    this.state.checkEvent = false;
    super.initState();
  }

  @override
  Future<RatingState> mapEventToState(RatingEvent event) async {
    if (event is EventPostRating) {
      await _postCommentRating(
          event.rateCommentModel, event.companyType, event.companyId);
      this.state.checkEvent = true;
    }
    return this.state;
  }

  Future _postCommentRating(
      RatingInput rateComment, String companyType, String companyId) async {
    final service = ServiceProxy();
    _rateComment = rateComment;

  this.state.isRated =  await service.companyServiceProxy
        .postComment(_rateComment, companyType, companyId);
  }
}
