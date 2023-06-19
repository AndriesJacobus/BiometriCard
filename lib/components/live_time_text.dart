import 'dart:async';
import 'package:flutter/material.dart';
import 'package:biometricard/common/colors.dart';
import 'package:timeago/timeago.dart' as timeago;

class LiveTimeText extends StatefulWidget {
  final String timeString;

  const LiveTimeText({super.key, required this.timeString});

  @override
  State<StatefulWidget> createState() {
    return LiveTimeTextState();
  }
}

class LiveTimeTextState extends State<LiveTimeText> {
  @override
  void initState() {
    super.initState();

    setState(() {
      const period = Duration(minutes: 1);
      Timer.periodic(period, (Timer t) {
        // debugPrint("Updating text...");
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime cardCreatedAt = DateTime.parse(widget.timeString);
    return Text(
      'Added ${timeago.format(cardCreatedAt).toString()}',
      style: const TextStyle(
        color: AppColors.persianGreen,
        fontSize: 14,
      ),
    );
  }
}
