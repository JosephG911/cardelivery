import 'package:blearn/pages/additional_settings.dart';
import 'package:blearn/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../globals.dart';
import 'package:blearn/Widgets/drugs.dart';

class SetAlarm extends StatefulWidget {
  final VoidCallback? onRefresh;
  const SetAlarm({super.key, this.onRefresh});

  @override
  State<SetAlarm> createState() => _SetAlarmState();
}

class _SetAlarmState extends State<SetAlarm> {
  int selectedHour = 12;
  int selectedMinute = 0;
  String selectedPeriod = "AM";

  @override
  Widget build(BuildContext context) {
    final currentPatient = patients[selectedPatientIndex];
    final List alarms = currentPatient['alarms'];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Alarms",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: alarms.isEmpty
          ? const Center(
              child: Text(
                "No alarms setted yet",
                style: TextStyle(color: Colors.white24),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: alarms.length,
              itemBuilder: (context, index) {
                var alarm = alarms[index];
                bool isAct = alarm['isActive'] ?? true;
                return _buildAlarmTile(alarm, index, isAct, alarms);
              },
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(
                    patientDrugs: allDrugs,
                    onRefresh: () async => setState(() {}),
                  ),
                ),
              );
              _showQuickAdd(context);
            },
            backgroundColor: const Color(0xFFBB86FC),
            child: const Icon(Icons.medication, color: Colors.black),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () => _showQuickAdd(context),
            backgroundColor: const Color(0xFFBB86FC),
            child: const Icon(Icons.add, color: Colors.black, size: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildAlarmTile(dynamic alarm, int index, bool isAct, List alarms) {
    return GestureDetector(
      onLongPress: () => _handleDelete(index),
      onTap: () async {
        List<String> parts = alarm['time'].split(':');
        int h = int.parse(parts[0]);
        int m = int.parse(parts[1].split(' ')[0]);
        String p = parts[1].split(' ')[1];
        final currentPatientDrugs = List<Map<String, dynamic>>.from(
          (patients[selectedPatientIndex]['selectedDrugs'] as List? ?? []).map(
            (drug) => Map<String, dynamic>.from(drug),
          ),
        );
        allDrugs = currentPatientDrugs;

        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdditionalSettings(
              initialHour: h,
              initialMinute: m,
              initialPeriod: p,
              initialNote: alarm['note'],
              availableDrugs: currentPatientDrugs,
              initialSelectedDrugIds: List<String>.from(
                (alarm['selectedDrugIds'] as List? ?? []).map(
                  (e) => e.toString(),
                ),
              ),
              initialSnooze: alarm['snooze'] ?? 5,
              initialRepeat: alarm['repeat'] ?? "Once",
              isEditing: true,
            ),
          ),
        );

        if (result != null) {
          final updatedAlarm = <String, dynamic>{
            ...Map<String, dynamic>.from(alarm as Map),
            ...Map<String, dynamic>.from(result as Map),
          };
          updatedAlarm['note'] = alarmNoteFromDrugs(
            List<Map<String, dynamic>>.from(
              updatedAlarm['selectedDrugs'] ?? [],
            ),
          );

          // 🔥 السر هنا: بنحفظ في اللستة الرئيسية مباشرة بدل القديمة
          setState(
            () =>
                patients[selectedPatientIndex]['alarms'][index] = updatedAlarm,
          );
          if (widget.onRefresh != null) widget.onRefresh!();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1C1E),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alarm['time'],
                    style: TextStyle(
                      color: isAct ? Colors.white : Colors.white24,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${alarmNoteFromDrugs(List<Map<String, dynamic>>.from(alarm['selectedDrugs'] ?? []))} - ${alarm['repeat'] ?? 'Once'}",
                    style: const TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                ],
              ),
            ),
            CupertinoSwitch(
              value: isAct,
              activeColor: const Color(0xFFBB86FC),
              onChanged: (v) {
                // 🔥 وهنا كمان بنغير الحالة في اللستة الرئيسية مباشرة
                setState(
                  () =>
                      patients[selectedPatientIndex]['alarms'][index]['isActive'] =
                          v,
                );
                if (widget.onRefresh != null) widget.onRefresh!();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Set Alarm",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _scrollUnit(
                    1,
                    12,
                    selectedHour,
                    (v) => setModalState(() => selectedHour = v),
                  ),
                  const Text(
                    ":",
                    style: TextStyle(color: Colors.white24, fontSize: 30),
                  ),
                  _scrollUnit(
                    0,
                    59,
                    selectedMinute,
                    (v) => setModalState(() => selectedMinute = v),
                  ),
                  _ampmUnit(setModalState),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        final res = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdditionalSettings(
                              initialHour: selectedHour,
                              initialMinute: selectedMinute,
                              initialPeriod: selectedPeriod,
                              initialNote: allDrugs
                                  .map((d) => d['name'])
                                  .join(', '),
                              availableDrugs: List<Map<String, dynamic>>.from(
                                (patients[selectedPatientIndex]['selectedDrugs']
                                            as List? ??
                                        [])
                                    .map(
                                      (drug) => Map<String, dynamic>.from(drug),
                                    ),
                              ),
                            ),
                          ),
                        );
                        if (res != null) {
                          setState(
                            () => patients[selectedPatientIndex]['alarms'].add(
                              res,
                            ),
                          );
                          allDrugs = [];
                          Navigator.pop(context);
                          if (widget.onRefresh != null) widget.onRefresh!();
                        }
                      },
                      child: const Text("Advanced"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBB86FC),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          final selectedAlarmDrugs =
                              List<Map<String, dynamic>>.from(allDrugs);
                          patients[selectedPatientIndex]['alarms'].add({
                            "time":
                                "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')} $selectedPeriod",
                            "note": alarmNoteFromDrugs(selectedAlarmDrugs),
                            "isActive": true,
                            "snooze": 5,
                            "repeat": "Once",
                            "selectedDrugIds": selectedAlarmDrugs
                                .map(drugIdentifier)
                                .toList(),
                            "selectedDrugs": selectedAlarmDrugs,
                          });
                          allDrugs = [];
                        });
                        Navigator.pop(context);
                        if (widget.onRefresh != null) widget.onRefresh!();
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scrollUnit(int min, int max, int init, Function(int) onSet) =>
      SizedBox(
        width: 70,
        height: 120,
        child: CupertinoPicker(
          itemExtent: 40,
          scrollController: FixedExtentScrollController(
            initialItem: init - min,
          ),
          onSelectedItemChanged: onSet,
          children: List.generate(
            max - min + 1,
            (i) => Center(
              child: Text(
                "${min + i}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      );

  Widget _ampmUnit(StateSetter set) => SizedBox(
    width: 70,
    height: 120,
    child: CupertinoPicker(
      itemExtent: 40,
      onSelectedItemChanged: (i) =>
          set(() => selectedPeriod = i == 0 ? "AM" : "PM"),
      children: const [
        Center(
          child: Text("AM", style: TextStyle(color: Colors.white)),
        ),
        Center(
          child: Text("PM", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );

  void _handleDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1C1E),
        title: const Text(
          "Delete Alarm",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Want to delete this alarm ?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(
                () => patients[selectedPatientIndex]['alarms'].removeAt(index),
              );
              if (widget.onRefresh != null) widget.onRefresh!();
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
