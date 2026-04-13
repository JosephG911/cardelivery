import 'package:flutter/material.dart';
import 'package:blearn/Widgets/drugs.dart';

class AddDelivery extends StatelessWidget {
  final List<Map<String, dynamic>> patientDrugs;
  final Future<void> Function() onRefresh;

  const AddDelivery({
    super.key,
    required this.patientDrugs,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Add'), backgroundColor: Colors.black),
        body: MainPage(patientDrugs: patientDrugs, onRefresh: onRefresh),
      ),
    );
  }
}
