import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../globals.dart';

class AdditionalSettings extends StatefulWidget {
  final int initialHour;
  final int initialMinute;
  final String initialPeriod;
  final String initialNote;
  final List<Map<String, dynamic>> availableDrugs;
  final List<String> initialSelectedDrugIds;
  final int initialSnooze;
  final String initialRepeat;
  final bool isEditing;

  const AdditionalSettings({
    super.key,
    required this.initialHour,
    required this.initialMinute,
    required this.initialPeriod,
    required this.initialNote,
    this.availableDrugs = const [],
    this.initialSelectedDrugIds = const [],
    this.initialSnooze = 5,
    this.initialRepeat = "Once",
    this.isEditing = false,
  }); 
  @override
  State<AdditionalSettings> createState() => _AdditionalSettingsState();
} 

class _AdditionalSettingsState extends State<AdditionalSettings> {
  late int selectedHour;
  late int selectedMinute;
  late String selectedPeriod;
  late int snoozeMinutes;
  late String selectedRepeat;
  late List<String> selectedMedicineIds;
  late List<Map<String, dynamic>> availableDrugs;

  final List<String> repeatOptions = [
    "Once",
    "Daily",
    "Mon-Fri",
    "Weekend",
    "Weekly",
  ];

  @override
  void initState() {
    super.initState();
    selectedHour = widget.initialHour;
    selectedMinute = widget.initialMinute;
    selectedPeriod = widget.initialPeriod;
    snoozeMinutes = widget.initialSnooze;
    selectedRepeat = widget.initialRepeat;
    availableDrugs = widget.availableDrugs.isNotEmpty
        ? List<Map<String, dynamic>>.from(widget.availableDrugs)
        : List<Map<String, dynamic>>.from(allDrugs);
    selectedMedicineIds = widget.isEditing
        ? List<String>.from(widget.initialSelectedDrugIds)
        : <String>[];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          widget.isEditing ? "Edit Alarm" : "New Alarm",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("SET TIME"),
            const SizedBox(height: 15),
            
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1C1E),
                borderRadius: BorderRadius.circular(25),
              ), 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPicker(
                    1,
                    12,
                    selectedHour,
                    (v) => setState(() => selectedHour = v),
                  ),
                  const Text(
                    ":",
                    style: TextStyle(
                      color: Color(0xFFBB86FC),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildPicker(
                    0,
                    59,
                    selectedMinute,
                    (v) => setState(() => selectedMinute = v),
                  ),
                  _buildAMPM(),
                ], 
              ), 
            ), 
            const SizedBox(height: 30),

            _label("REPEAT"),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1C1E),
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButton<String>(
                value: selectedRepeat,
                dropdownColor: const Color(0xFF1A1C1E),
                isExpanded: true,
                underline: const SizedBox(),
                style: const TextStyle(color: Colors.white),
                items: repeatOptions
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (v) => setState(() => selectedRepeat = v!),
              ), 
            ), 
            const SizedBox(height: 30),

            _label("SNOOZE: $snoozeMinutes MINUTES"),
            Slider(
              value: snoozeMinutes.toDouble(),
              min: 0,
              max: 30,
              divisions: 6,
              activeColor: const Color(0xFFBB86FC),
              inactiveColor: Colors.white10,
              onChanged: (v) => setState(() => snoozeMinutes = v.toInt()),
            ), 
            const SizedBox(height: 30),

            _label("SELECT MEDICINES FOR THIS TIME"),
            const SizedBox(height: 10),
            availableDrugs.isEmpty
                ? const Text(
                    "No drugs found. Please select drugs from the main list first.",
                    style: TextStyle(color: Colors.white24),
                  )
                : Wrap(
                    spacing: 8,
                    children: availableDrugs
                        .where((drug) => (drug['count'] ?? 0) > 0)
                        .map((drug) {
                          final drugId = drugIdentifier(drug);
                          bool isSelected = selectedMedicineIds.contains(
                            drugId,
                          );

                          return FilterChip(
                            label: Text(drug['name']),
                            selected: isSelected,
                            onSelected: (val) {
                              setState(() {
                                if (val) {
                                  selectedMedicineIds.add(drugId);
                                } else {
                                  selectedMedicineIds.remove(drugId);
                                }
                              });
                            },
                          );
                        })
                        .toList(),
                  ),

            const SizedBox(height: 50),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBB86FC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  final selectedDrugs = availableDrugs
                      .where(
                        (drug) => selectedMedicineIds.contains(
                          drugIdentifier(drug),
                        ),
                      )
                      .toList();

                  Navigator.pop(context, {
                    "time":
                        "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')} $selectedPeriod",
                    "note": alarmNoteFromDrugs(selectedDrugs),
                    "snooze": snoozeMinutes,
                    "repeat": selectedRepeat,
                    "isActive": true,
                    "selectedDrugIds": selectedDrugs.map(drugIdentifier).toList(),
                    "selectedDrugs": selectedDrugs,
                  });
                },
                child: const Text(
                  "SAVE ALARM",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String t) => Text(
    t,
    style: const TextStyle(
      color: Colors.white38,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
  );

  Widget _buildPicker(int min, int max, int init, Function(int) onSet) =>
      Expanded(
        child: CupertinoPicker(
          scrollController: FixedExtentScrollController(
            initialItem: init - min,
          ),
          itemExtent: 40,
          onSelectedItemChanged: (i) {
            HapticFeedback.selectionClick();
            onSet(min + i);
          },
          children: List.generate(
            max - min + 1,
            (i) => Center(
              child: Text(
                (min + i).toString().padLeft(2, '0'),
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      );

  Widget _buildAMPM() => Expanded(
    child: CupertinoPicker(
      scrollController: FixedExtentScrollController(
        initialItem: selectedPeriod == "AM" ? 0 : 1,
      ),
      itemExtent: 40,
      onSelectedItemChanged: (i) =>
          setState(() => selectedPeriod = i == 0 ? "AM" : "PM"),
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
}
