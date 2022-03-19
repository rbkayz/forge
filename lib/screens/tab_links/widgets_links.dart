import 'package:flutter/material.dart';
import 'package:forge/utilities/constants.dart';
import 'package:intl/intl.dart';

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

class FrequencyWidget extends StatelessWidget {

  const FrequencyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                    '3 MONTHS',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
              Text(
                'Frequency',
                style: TextStyle(fontSize: 10, color: Constants.kSecondaryColor, fontWeight: FontWeight.w400),
              ),
            ],
          ),
    );
  }
}

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
              children: [
                Text(
                    DateFormat('dd-MMM').format(widget.start).toUpperCase(),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const Text(
                  'Last connected',
                  style: TextStyle(fontSize: 10, color: Constants.kSecondaryColor,fontWeight: FontWeight.w400),),
              ],
            ),
          ),
        Expanded(
          flex: 3,
          child: Center(
            child: Text(
              'Next connect in ${widget.end.difference(widget.current).inDays} days',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Text(
                DateFormat('dd-MMM').format(widget.end).toUpperCase(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Text(
                'Next connect',
                style: TextStyle(fontSize: 10, color: Constants.kSecondaryColor, fontWeight: FontWeight.w400),),
            ],
          ),
        ),
      ],
    );
  }
}
