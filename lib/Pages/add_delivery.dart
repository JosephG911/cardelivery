import 'package:flutter/material.dart';
import 'package:blearn/Widgets/drugs.dart';

class AddDelivery extends StatelessWidget {
  const AddDelivery({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Add')),

        body: MainPage(),
      ),
    );
  }
}
