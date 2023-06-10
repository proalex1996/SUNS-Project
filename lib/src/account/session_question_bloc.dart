import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/feedback_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class QuestionState {
  FeedbackModel model;
  QuestionState({this.model});
}

abstract class QuestionEvent {}

class CreateQuestionEvent extends QuestionEvent {
  String title;
  String content;
  FeedbackModel model;

  CreateQuestionEvent({this.title, this.content, this.model});
}

class QuestionBloc extends BlocBase<QuestionEvent, QuestionState> {
  FeedbackModel model = new FeedbackModel();
  @override
  void initState() {
    super.initState();
  }

  @override
  Future<QuestionState> mapEventToState(QuestionEvent event) async {
    if (event is CreateQuestionEvent) {
      await _createQuestion(event.title, event.content);
    }
    return this.state;
  }

  Future _createQuestion(String title, String content) async {
    final service = ServiceProxy().hospitalService;
    model?.title = title;
    model?.content = content;
    this.model = await service.feedback(model);
  }
}
