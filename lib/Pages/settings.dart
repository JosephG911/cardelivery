import 'package:flutter/material.dart';
import 'package:blearn/Notifires/dark_mode.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Settings')),
        body: Column(
          children: [
            //todo: implement dark mode switch
              
            // ValueListenableBuilder(
            //   valueListenable: darkModeNotifier,
            //   builder: (context, value, _) {
            //     return Card(bool: color, child: Container(height: 100));
            //   },
            // ),
            IconButton(onPressed: () {
if (darkModeNotifier.value) {
  darkModeNotifier.value = false;
} else {
  darkModeNotifier.value = true;
}

            }, icon: Icon(Icons.light_mode_outlined)),
          ],
        ),
      ),
    );
  }
}
