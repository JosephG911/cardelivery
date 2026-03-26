import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(
                'Car',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800],
                ),
              ),
              Text('Delivery'),
              Expanded(child: SizedBox()),
              // Container(
              //   margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
              //   child: Icon(Icons.camera_alt_outlined),
              // ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                child: Icon(Icons.more_vert),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(3.5),
            child: Divider(
              color: const Color.fromARGB(255, 88, 88, 88),
              thickness: 2,
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Column(
            children: [
              Container(
                // margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
                height: 220,
                width: 350,

                child: Card(
                  surfaceTintColor: Colors.purple[300],
                  color: const Color.fromARGB(255, 122, 122, 122),
                  shadowColor: Color.fromARGB(255, 105, 105, 105),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 20,
                  child: Column(
                    children: [
                      AppBar(
                        title: Text(
                          'state',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(115, 0, 0, 0),
                            fontFamily: String.fromEnvironment('sans-serif'),
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                      // Icon(Icons.add, color: Colors.red),
                      Text(
                        '',
                        style: TextStyle(
                          color: Color.fromARGB(255, 205, 205, 205),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Container(
              //   margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
              //   padding: EdgeInsets.all(1),
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: const Color.fromARGB(255, 88, 88, 88),

              //     // gradient: LinearGradient(
              //     //   colors: [Colors.blue, Colors.purple],
              //     // ),
              //   ),
              //   child: CircleAvatar(
              //     // radius: ,
              //     backgroundColor: Color(0xFF121212),
              //     child: Icon(Icons.person_2_outlined),
              //   ),
              // ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 30, 0, 20),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
                      height: 100,
                      width: 150,

                      child: Card(
                        surfaceTintColor: Colors.deepPurpleAccent,

                        color: const Color.fromARGB(255, 105, 105, 105),
                        shadowColor: Color.fromARGB(255, 105, 105, 105),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Colors.red),
                            Text(
                              'Add Medicine',
                              style: TextStyle(
                                color: Color.fromARGB(255, 205, 205, 205),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      // margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
                      height: 100,
                      width: 150,

                      child: Card(
                        surfaceTintColor: Colors.deepPurpleAccent,

                        color: const Color.fromARGB(255, 105, 105, 105),

                        shadowColor: Color.fromARGB(255, 105, 105, 105),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.alarm, color: Colors.blue),
                            Text(
                              'Set Alarm',
                              style: TextStyle(
                                color: Color.fromARGB(255, 205, 205, 205),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
