import 'package:blearn/Widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:blearn/Pages/statics.dart';
import 'package:blearn/Pages/add_delivery.dart';
import 'package:blearn/Pages/set_alarm.dart';
import 'package:blearn/Pages/settings.dart';
import 'package:blearn/Pages/profile.dart';

class Chome extends StatelessWidget {
  Chome({super.key});
  final ValueNotifier<Color> cardColor = ValueNotifier(Colors.grey);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Color(0xFF1E0D38),
        appBar: AppBar(
          // backgroundColor: Color(0xFF3B0F70),
          elevation: 6,
          title: Row(
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(
                'Car',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFBB86FC),
                ),
              ),
              SizedBox(width: 6),
              Text(
                'Delivery',
                style: TextStyle(fontSize: 28, color: Colors.white70),
              ),
              Expanded(child: SizedBox()),
              Icon(Icons.more_vert, color: Color(0xFF929292)),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(3),
            child: Divider(color: Colors.grey[700], thickness: 2),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Color.fromARGB(255, 83, 83, 83),

                elevation: 16,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Statics()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 220,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'State',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                        Spacer(),
                        Center(
                          child: Text(
                            'Car Delivery Status',
                            style: TextStyle(
                              fontSize: 20,
                              // fontWeight: FontWeight.w600,
                              color: Colors.white,
                              // color: Color(0xFFBB86FC),
                            ),
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.local_shipping,
                              //  color: Colors.white
                              color: Color(0xFFBB86FC),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CustomCard(
                      icon: Icons.add,
                      i: AddDelivery(),
                      name: 'Add Medicine',
                    ),
                    SizedBox(width: 12),

                    CustomCard(
                      icon: Icons.alarm,
                      i: SetAlarm(),
                      name: 'Set Alarm',
                    ),
                    SizedBox(width: 12),
                    CustomCard(
                      icon: Icons.person,
                      i: Profile(),
                      name: 'Profile',
                    ),
                    SizedBox(width: 12),

                    CustomCard(
                      icon: Icons.settings,
                      i: Settings(),
                      name: 'Settings',
                    ),
                  ],
                ),
              ),

              //todo: filters
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.transparent,
              //     // padding: EdgeInsets.symmetric(horizontal: 24, svertical: 12),
              //     side: BorderSide(color: Colors.white70, width: 0.2),
              //   ),
              //   onPressed: () {
              //     cardColor.value = Colors.purple;
              //     Text(
              //       '',
              //       style: TextStyle(color: Colors.white70, fontSize: 16),
              //     );
              //   },
              //   child: Text('r'),
              // ),
              // ValueListenableBuilder(
              //   valueListenable: cardColor,
              //   builder: (context, color, _) {
              //     return Card(color: color, child: Container(height: 100));
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
