import 'package:flutter/material.dart';
import '../globals.dart';

class SetAlarm extends StatefulWidget {
  final VoidCallback? onRefresh;

  const SetAlarm({super.key, this.onRefresh});

  @override
  State<SetAlarm> createState() => _SetAlarmState();
}

class _SetAlarmState extends State<SetAlarm> {
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentPatient = patients[selectedPatientIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Set Alarm",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFBB86FC)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[800]!),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Selected Time",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            selectedTime.format(context),
                            style: TextStyle(
                              color: Color(0xFFBB86FC),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.dark().copyWith(
                                  colorScheme: ColorScheme.dark(
                                    primary: Color(0xFFBB86FC),
                                    onPrimary: Colors.black,
                                    surface: Colors.grey[900]!,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null)
                            setState(() => selectedTime = picked);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFBB86FC),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text("Change"),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: noteController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Medicine name or note...",
                      hintStyle: TextStyle(color: Colors.white24),
                      filled: true,
                      fillColor: Colors.black,
                      prefixIcon: Icon(
                        Icons.edit,
                        color: Colors.white54,
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey[800]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey[800]!),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (noteController.text.trim().isEmpty) return;
                        setState(() {
                          currentPatient['alarms'].add({
                            "time": selectedTime.format(context),
                            "note": noteController.text.trim(),
                          });
                        });
                        if (widget.onRefresh != null) widget.onRefresh!();

                        noteController.clear();
                        FocusScope.of(context).unfocus();
                      },
                      icon: Icon(Icons.alarm_add),
                      label: Text(
                        "Add Alarm",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            Row(
              children: [
                Icon(
                  Icons.notifications_active,
                  color: Color(0xFFBB86FC),
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  "Alarms for ${currentPatient['name']}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),

            Expanded(
              child: currentPatient['alarms'].isEmpty
                  ? Center(
                      child: Text(
                        "No alarms set",
                        style: TextStyle(color: Colors.white30),
                      ),
                    )
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: currentPatient['alarms'].length,
                      itemBuilder: (context, index) {
                        var alarm = currentPatient['alarms'][index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.access_time,
                                color: Color(0xFFBB86FC),
                              ),
                            ),
                            title: Text(
                              alarm['time'],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              alarm['note'],
                              style: TextStyle(color: Colors.white54),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                setState(() {
                                  currentPatient['alarms'].removeAt(index);
                                });
                                if (widget.onRefresh != null)
                                  widget.onRefresh!();
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
