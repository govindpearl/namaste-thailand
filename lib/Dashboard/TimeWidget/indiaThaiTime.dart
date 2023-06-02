import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DualClockWidget extends StatefulWidget {
  @override
  _DualClockWidgetState createState() => _DualClockWidgetState();
}

class _DualClockWidgetState extends State<DualClockWidget> {
  late Stream<DateTime> _indiaClockStream;
  late Stream<DateTime> _thailandClockStream;
  late DateFormat _dateFormat;

  @override
  void initState() {
    super.initState();
    _indiaClockStream = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now().toUtc().add(Duration(hours: 5, minutes: 30)));
    _thailandClockStream = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now().toUtc().add(Duration(hours: 7)));
    _dateFormat = DateFormat('hh:mm:ss a');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildClockWidget('India', _indiaClockStream),
        SizedBox(width: 5,),
        _buildClockWidget('Thailand', _thailandClockStream),
      ],
    );
  }

  Widget _buildClockWidget(String label, Stream<DateTime> clockStream) {
    return StreamBuilder<DateTime>(
      stream: clockStream,
      builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) {
        if (!snapshot.hasData) {
          return Text('Loading...');
        }
        var time = snapshot.data;
        var formattedTime = _dateFormat.format(time!);
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: GoogleFonts.poppins(color: Colors.grey[600], fontWeight: FontWeight.w500, ),),

            SizedBox(height: 5.0),
            Text(formattedTime, style: GoogleFonts.poppins(color: Colors.grey[600], fontWeight: FontWeight.w500, ),)
          ],
        );
      },
    );
  }
}
