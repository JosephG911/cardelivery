import 'package:blearn/Widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blearn/Pages/statics.dart';
import 'package:blearn/Pages/add_delivery.dart';
import 'package:blearn/Pages/set_alarm.dart';
// import 'package:blearn/Pages/settings.dart';
import 'package:blearn/Pages/profile.dart';
import 'package:uuid/uuid.dart';
import 'globals.dart';

class Chome extends StatefulWidget {
  const Chome({super.key});

  @override
  State<Chome> createState() => _ChomeState();
}

class _ChomeState extends State<Chome> {
  final ValueNotifier<Color> cardColor = ValueNotifier(Colors.grey);
  final uuid = const Uuid();

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text("Delete Patient", style: TextStyle(color: Colors.white)),
        content: Text(
          "Are you sure you want to delete ${patients[index]['name']}?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              setState(() {
                patients.removeAt(index);
                if (selectedPatientIndex >= patients.length) {
                  selectedPatientIndex = patients.isEmpty
                      ? 0
                      : patients.length - 1;
                }
              });
              Navigator.pop(context);
            },
            child: Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (selectedPatientIndex >= patients.length) {
      selectedPatientIndex = patients.isEmpty ? 0 : patients.length - 1;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
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
              PopupMenuButton<String>(
                color: Colors.grey[900],
                icon: const Icon(Icons.more_vert, color: Color(0xFF929292)),
                itemBuilder: (context) => const [],
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 65,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: patients.length + 1,
                itemBuilder: (context, index) {
                  if (index == patients.length) {
                    return IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            TextEditingController controller =
                                TextEditingController();
                            return AlertDialog(
                              backgroundColor: Colors.grey[900],
                              title: Text(
                                "Add Patient",
                                style: TextStyle(color: Colors.white),
                              ),
                              content: TextField(
                                controller: controller,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Patient name",
                                  hintStyle: TextStyle(color: Colors.white54),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    String name = controller.text.trim();
                                    if (name.isNotEmpty) {
                                      setState(() {
                                        patients.add({
                                          "id": uuid.v4(),
                                          "name": name,
                                          "selectedDrugs":
                                              <Map<String, dynamic>>[],
                                          "alarms": <Map<String, dynamic>>[],
                                        });
                                        selectedPatientIndex =
                                            patients.length - 1;
                                        allDrugs = [];
                                      });
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Text("Add"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: Color(0xFFBB86FC),
                      ),
                    );
                  }

                  bool isSelected = selectedPatientIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onLongPress: () {
                        if (patients.length > 1) {
                          _showDeleteDialog(context, index);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "There should be at least one patient",
                              ),
                            ),
                          );
                        }
                      },
                      child: ChoiceChip(
                        label: Text(patients[index]['name']),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            selectedPatientIndex = index;
                            allDrugs = List<Map<String, dynamic>>.from(
                              patients[index]['selectedDrugs'] as List? ?? [],
                            );
                          });
                        },
                        selectedColor: Color(0xFFBB86FC),
                        backgroundColor: Colors.grey[900],
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.black : Colors.white70,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: BorderSide.none,
                        showCheckmark: false,
                      ),
                    ),
                  );
                },
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: Color.fromARGB(255, 45, 45, 45),
                      elevation: 10,
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
                          height: 200,
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current Patient: ${patients[selectedPatientIndex]['name']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFBB86FC),
                                ),
                              ),
                              Spacer(),
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      '${patients[selectedPatientIndex]['selectedDrugs'].length} Medicines',
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${patients[selectedPatientIndex]['alarms'].length} Active Alarms',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white60,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Click for stats",
                                    style: TextStyle(
                                      color: Colors.white30,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Icon(
                                    Icons.list_alt_sharp,
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
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                          CustomCard(
                            icon: Icons.add,
                            i: AddDelivery(
                              patientDrugs:
                                  (patients[selectedPatientIndex]['selectedDrugs']
                                          as List)
                                      .cast<Map<String, dynamic>>(),
                              onRefresh: () => setState(() {}),
                            ),
                            name: 'Add Medicine',
                          ),
                          SizedBox(width: 12),
                          CustomCard(
                            icon: Icons.alarm,
                            i: SetAlarm(onRefresh: () => setState(() {})),
                            name: 'Set Alarm',
                          ),
                          SizedBox(width: 12),
                          CustomCard(
                            icon: Icons.person,
                            i: Profile(),
                            name: 'Profile',
                          ),
                          SizedBox(width: 12),
                          /*
                          CustomCard(
                            icon: Icons.settings,
                            i: Settings(),
                            name: 'Settings',
                          ),*/
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
