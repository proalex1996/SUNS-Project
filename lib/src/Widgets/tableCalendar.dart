import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:suns_med/common/theme/theme_color.dart';

class CalendarScreen extends StatefulWidget {
  final Function(DateTime dateTime) onChanage;
  final bool Function(DateTime) enabledDayPredicate;
  CalendarScreen({@required this.onChanage, this.enabledDayPredicate});
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarController _calendarController;
  Map<DateTime, List> _events;
  List<dynamic> selectedEvents;
  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var useMobileLayout = shortestSide < 600;
    return Container(
      child: TableCalendar(
        startDay: DateTime.now(),
        endDay: DateTime(2100),
        initialSelectedDay: DateTime.now(),
        locale: 'en_US',
        events: _events,
        initialCalendarFormat: CalendarFormat.month,
        enabledDayPredicate: widget.enabledDayPredicate,
        calendarStyle: CalendarStyle(
          todayStyle: TextStyle(
              fontFamily: 'Montserrat-M',
              fontSize: useMobileLayout ? 18 : 30,
              color: Colors.white),
          weekendStyle: TextStyle(
            fontFamily: 'Montserrat-M',
            color: AppColor.warmGrey,
          ),
          outsideDaysVisible: false,
        ),
        headerStyle: HeaderStyle(
            headerMargin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.15,
                vertical: 25),
            centerHeaderTitle: true,
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: AppColor.darkPurple,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: AppColor.darkPurple,
            ),
            titleTextStyle: TextStyle(
              fontFamily: 'Montserrat-M',
              color: AppColor.darkPurple,
              fontSize: useMobileLayout ? 18 : 20,
            ),
            formatButtonVisible: false,
            formatButtonShowsNext: false),
        startingDayOfWeek: StartingDayOfWeek.monday,
        daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
                fontFamily: 'Montserrat-M',
                color: AppColor.darkPurple,
                fontSize: useMobileLayout ? 16 : 28,
                fontWeight: FontWeight.bold),
            weekendStyle: TextStyle(
                fontFamily: 'Montserrat-M',
                color: AppColor.darkPurple,
                fontSize: useMobileLayout ? 16 : 28,
                fontWeight: FontWeight.bold)),
        onDaySelected: (date, events, _) {
          setState(() {
            selectedEvents = events;
            this.widget.onChanage(date);
          });
        },
        builders: CalendarBuilders(
            unavailableDayBuilder: (context, date, enevts) => Container(
                margin: EdgeInsets.all(4),
                alignment: Alignment.center,
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    color: Colors.grey,
                    fontSize: useMobileLayout ? 16 : 28,
                    //fontWeight: FontWeight.bold
                  ),
                )),
            dayBuilder: (context, date, enevts) => Container(
                margin: EdgeInsets.all(4),
                alignment: Alignment.center,
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    color: Colors.black,
                    fontSize: useMobileLayout ? 16 : 28,
                  ),
                )),
            selectedDayBuilder: (context, date, events) => Container(
                  margin:
                      useMobileLayout ? EdgeInsets.all(4) : EdgeInsets.all(40),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColor.orangeColor, shape: BoxShape.circle),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      color: Colors.white,
                      fontSize: useMobileLayout ? 16 : 28,
                    ),
                  ),
                ),
            todayDayBuilder: (context, date, enevts) => Container(
                margin:
                    useMobileLayout ? EdgeInsets.all(4) : EdgeInsets.all(40),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColor.orangeColor.withOpacity(0.5),
                    shape: BoxShape.circle),
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    color: Colors.white,
                    fontSize: useMobileLayout ? 16 : 28,
                  ),
                ))),
        calendarController: _calendarController,
      ),
    );
  }
}
