import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/src/Widgets/line_chart/chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';

class HealthChartScreen extends StatefulWidget {
  final int idContact;
  HealthChartScreen({@required this.idContact});
  @override
  _HealthChartScreenState createState() => _HealthChartScreenState();
}

class _HealthChartScreenState extends State<HealthChartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            CustomAppBar(
              title: AppLocalizations.of(context).healthInChart,
              titleSize: 18,
            ),
            _buildTextTitle(),
            _buildCardChart(),
            _buildNote(),
          ],
        ),
      ),
    );
  }

  _buildTextTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 35.0),
      child: Text(
        AppLocalizations.of(context).healthChart,
        style: TextStyle(
            fontFamily: 'Montserrat-M',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.deepBlue),
      ),
    );
  }

  _buildCardChart() {
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 35, top: 25),
      height: 300,
      child: ChartPage(idContact: widget?.idContact),
    );
  }

  _buildNote() {
    return Container(
      padding: const EdgeInsets.only(top: 48, left: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${AppLocalizations.of(context).note}:',
              style: TextStyle(
                  fontFamily: 'Montserrat-M',
                  fontSize: 16,
                  color: AppColor.deepBlue)),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 17,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(9)),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    AppLocalizations.of(context).weight,
                    style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 13),
                  )
                ],
              ),
              SizedBox(
                height: 7,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 17,
                    decoration: BoxDecoration(
                        color: AppColor.deepRed,
                        borderRadius: BorderRadius.circular(9)),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    AppLocalizations.of(context).bloodPressure,
                    style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 13),
                  )
                ],
              ),
              SizedBox(
                height: 7,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 17,
                    decoration: BoxDecoration(
                        color: AppColor.pumpkin,
                        borderRadius: BorderRadius.circular(9)),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    AppLocalizations.of(context).bloodSugar,
                    style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 13),
                  )
                ],
              ),
              SizedBox(
                height: 7,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 17,
                    decoration: BoxDecoration(
                        color: AppColor.deepBlue,
                        borderRadius: BorderRadius.circular(9)),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    AppLocalizations.of(context).bodyIndex,
                    style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 13),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
