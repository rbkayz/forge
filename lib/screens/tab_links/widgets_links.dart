import 'package:flutter/material.dart';
import 'package:forge/utilities/constants.dart';
import 'package:forge/utilities/widget_styles.dart';

class LinksTag extends StatelessWidget {
  const LinksTag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      child: const Text(
        '# PLACEHOLDER',
        style: TextStyle(fontSize: 12, color: Constants.kWhiteColor),
      ),
      decoration: BoxDecoration(
        color: Constants.kPrimaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

///--------------------------------------------------------------
/// Calendar Widget for the next meeting
///--------------------------------------------------------------

class NextConnectDateWidget extends StatelessWidget {
  const NextConnectDateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
          alignment: Alignment.center,
          decoration: forgeBoxDecoration(),
          height: 60,
          width: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              SizedBox(
                width: 30,
                child: FittedBox(
                  child: Text('23'),
                ),
              ),
              SizedBox(
                width: 30,
                child: FittedBox(
                  child: Text('MAR'),
                ),
              ),
            ],
          )),
    ]);
  }
}

///--------------------------------------------------------------
/// The Link Progress bar
///--------------------------------------------------------------


class LinkProgressBar extends StatefulWidget {
  const LinkProgressBar(
      {Key? key, required this.start, required this.current, required this.end})
      : super(key: key);

  final DateTime start;
  final DateTime current;
  final DateTime end;

  @override
  _LinkProgressBarState createState() => _LinkProgressBarState();
}

class _LinkProgressBarState extends State<LinkProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: const [
              LinkHeaderRowWidget(icon: Icons.event_outlined, text: 'Last connected on 31 Mar 2022 (81 days ago)'),
              SizedBox(height:12),
              LinkHeaderRowWidget(icon: Icons.repeat, text: 'Repeats every 3 months'),
              SizedBox(height:12),
              LinkHeaderRowWidget(icon: Icons.upcoming_outlined, text: 'Next connect in 20 days'),
            ],
          ),
        ),
      ],
    );
  }
}

class LinkHeaderRowWidget extends StatelessWidget {
  const LinkHeaderRowWidget({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14,color: Colors.grey.shade700,),
        const SizedBox(width: 4,),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
              color: Colors.grey.shade700,
          )
        ),
      ],
    );
  }
}