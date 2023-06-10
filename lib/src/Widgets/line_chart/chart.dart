import 'package:fl_animated_linechart/chart/animated_line_chart.dart';
import 'package:fl_animated_linechart/chart/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/line_chart/fake_chart_series.dart';
import 'package:suns_med/src/Widgets/line_chart/session_chart_bloc.dart';

class ChartPage extends StatefulWidget {
  final int idContact;

  ChartPage({this.idContact});
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> with FakeChartSeries {
  int chartIndex = 0;
  final bloc = HealthChartBloc();
  @override
  void initState() {
    bloc.dispatch(EventLoadHealth(idContact: widget.idContact));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HealthChartEvent, HealthChartState, HealthChartBloc>(
      bloc: bloc,
      builder: (state) {
        var weight =
            // (state.weights.values.length > 1)
            //     ? state?.weights
            //     : {DateTime.now(): 0.0, DateTime(2021, 1, 1): 0.0};
            state?.weights;
        var bloodGlucose =
            // (state.bloodGlucose.values.length > 1)
            //     ? state?.bloodGlucose
            //     : {DateTime.now(): 0.0, DateTime(2021, 1, 1): 0.0};
            state?.bloodGlucose;
        var bloodPressure =
            // (state.bloodPressure.values.length > 1)
            //     ? state?.bloodPressure
            //     : {DateTime.now(): 0.0, DateTime(2021, 1, 1): 0.0};
            state?.bloodPressure;
        var bmi =
            // (state.bmi.values.length > 1)
            //     ? state.bmi
            //     : {DateTime.now(): 0.0, DateTime(2021, 1, 1): 0.0};
            state.bmi;
        return (weight == null || bloodPressure == null || bloodGlucose == null)
            ? Center(
                child: Text('Không có dữ liệu để vẽ'),
              )
            : Container(
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AnimatedLineChart(
                          LineChart.fromDateTimeMaps([
                            weight,
                            bloodGlucose,
                            bloodPressure,
                            bmi
                          ], [
                            Colors.green,
                            AppColor.pumpkin,
                            AppColor.deepRed,
                            AppColor.deepBlue
                          ], [
                            ' ',
                            ' ',
                            ' ',
                            ' '
                          ], tapTextFontWeight: FontWeight.w400),
                          key: UniqueKey(),
                        ), //Unique key to force animations
                      )),
                    ]),
              );
      },
    );
  }
}
