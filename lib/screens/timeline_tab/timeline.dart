import 'package:flutter/material.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({Key? key}) : super(key: key);

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  int _count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _count = 0;
  }

  void _press() {
    setState(() {
      _count = _count + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: _press,
        child: Text(_count.toString()),
      ),
    );
  }
}
