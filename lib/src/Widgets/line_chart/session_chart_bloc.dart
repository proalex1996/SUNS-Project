import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/contact/dto/heal_chart_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class HealthChartState {
  List<HealthChartModel> healthChart;
  HealthChartModel healthInfo;
  Map<DateTime, double> bmi;
  Map<DateTime, double> weights;
  Map<DateTime, double> bloodGlucose;
  Map<DateTime, double> bloodPressure;
  HealthChartState({this.healthChart});
}

abstract class HealthChartEvent {}

class EventLoadHealth extends HealthChartEvent {
  int idContact;
  EventLoadHealth({this.idContact});
}

class HealthChartBloc extends BlocBase<HealthChartEvent, HealthChartState> {
  @override
  void initState() {
    this.state = HealthChartState();
    super.initState();
    ensureHasData();
  }

  @override
  Future<HealthChartState> mapEventToState(HealthChartEvent event) async {
    if (event is EventLoadHealth) {
      await _getHealthChart(event.idContact);
    }
    return this.state;
  }

  Future _getHealthChart(int idContact) async {
    final service = ServiceProxy().contactSeviceProxy;
    this.state.healthChart = await service.getHealthChart(idContact);

    this.state.weights = {};
    this.state.bloodGlucose = {};
    this.state.bloodPressure = {};
    this.state.bmi = {};
    this.state.healthChart.forEach((x) {
      var date =
          DateTime(x.createdTime.year, x.createdTime.month, x.createdTime.day);

      if (!this.state.weights.containsKey(date)) {
        this.state.weights[date] = x.weight?.toDouble() ?? 0.0;

        this.state.bloodGlucose[date.subtract(Duration(seconds: -2))] =
            x.bloodGlucose?.toDouble() ?? 0.0;
        var temp =
            x.systolicBloodPressure != null && x.diastolicBloodPressure != null
                ? x.systolicBloodPressure.toDouble() /
                    x.diastolicBloodPressure.toDouble()
                : 0.0;

        this.state.bloodPressure[date.subtract(Duration(seconds: -3))] = temp;
        var heightMeters =
            (x?.height == null) ? 0.0 : x.height.toDouble() / 100;
        var bmi = (x.weight != null && x.height != null && x.height != 0.0)
            ? x.weight.toDouble() /
                (heightMeters.toDouble() * heightMeters.toDouble())
            : 0.0;
        this.state.bmi[date.subtract(Duration(seconds: -4))] = bmi;
      }
    });

    ensureHasData();
  }

  void ensureHasData() {
    if (this.state.weights?.isNotEmpty != true || this.state.weights == null) {
      this.state.weights = Map<DateTime, double>();
      this.state.weights[DateTime.now().subtract(Duration(seconds: 1))] = 0;
    }
    if (this.state.bloodGlucose?.isNotEmpty != true ||
        this.state.bloodGlucose == null) {
      this.state.bloodGlucose = Map<DateTime, double>();
      this.state.bloodGlucose[DateTime.now().subtract(Duration(seconds: 2))] =
          0;
    }
    if (this.state.bloodPressure?.isNotEmpty != true ||
        this.state.bloodPressure == null) {
      this.state.bloodPressure = Map<DateTime, double>();
      this.state.bloodPressure[DateTime.now().subtract(Duration(seconds: 3))] =
          0;
    }
    if (this.state.bmi?.isNotEmpty != true || this.state.bmi == null) {
      this.state.bmi = Map<DateTime, double>();
      this.state.bmi[DateTime.now().subtract(Duration(seconds: 4))] = 0;
    }
  }
}
