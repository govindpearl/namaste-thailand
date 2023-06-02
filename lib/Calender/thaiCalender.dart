/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ThaiCalender extends StatefulWidget {
  const ThaiCalender({Key? key}) : super(key: key);

  @override
  State<ThaiCalender> createState() => _ThaiCalenderState();
}

class _ThaiCalenderState extends State<ThaiCalender> {
  List<Meeting> _getDataSource(){
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(2023,03,31, 0,0,0);
    final DateTime endTime = startTime.add(const Duration(hours: 9));
    meetings.add(Meeting('Conference 1', startTime, endTime, const Color(0xFF0F8644), false));

    return meetings;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
      ),
      body: SfCalendar(
        view: CalendarView.month,
        cellBorderColor: Colors.transparent,
        dataSource: MeetingDataSource(_getDataSource()),
        monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
          showAgenda: true
        ),
        blackoutDates: [
          DateTime.now().subtract(Duration(hours: 48)),
          DateTime.now().subtract(Duration(hours: 24))
        ],
      ),
    );
  }
}
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
*/
