import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'color_mode.dart';

class ShowDate extends StatelessWidget {
  final dateTime;
  const ShowDate({Key? key, required this.dateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        DateFormat.yMMMd().add_jm().format(dateTime.toDate()),
        style: TextStyle(
        ),
      ),
    );
  }
}
