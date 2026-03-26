import 'package:flutter/material.dart';

class SetAlarm extends StatelessWidget {
  const SetAlarm({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(appBar: AppBar(title: Text('Set Alarm'))),
    );
  }
}
