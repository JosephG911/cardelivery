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
  late Set<String> selectedMedicineIds;
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

    // تحسين: قراءة الأدوية من المريض الحالي مباشرة لضمان الدقة
    final currentPatientDrugs = List<Map<String, dynamic>>.from(
      patients[selectedPatientIndex]['selectedDrugs'] ?? [],
    );

    // نستخدم الأدوية الممرة أو أدوية المريض المختار كبديل
    final sourceDrugs = widget.availableDrugs.isNotEmpty
        ? List<Map<String, dynamic>>.from(widget.availableDrugs)
        : currentPatientDrugs;

    availableDrugs = _dedupeDrugs(sourceDrugs);

    // تحويل الـ IDs المدخلة إلى Set للمقارنة السريعة
    selectedMedicineIds = widget.initialSelectedDrugIds
        .map((id) => id.toString().trim())
        .toSet();
  }

  // دالة لمنع تكرار الأدوية بناءً على المعرف الفريد
  List<Map<String, dynamic>> _dedupeDrugs(List<Map<String, dynamic>> drugs) {
    final unique = <String, Map<String, dynamic>>{};
    for (final drug in drugs) {
      unique[drugIdentifier(drug)] = Map<String, dynamic>.from(drug);
    }
    return unique.values.toList();
  }

  // تحسين: التبديل الفوري لحالة الاختيار مع اهتزاز بسيط (Haptic)
  void _toggleMedicineSelection(String drugId) {
    HapticFeedback.lightImpact();
    setState(() {
      if (selectedMedicineIds.contains(drugId)) {
        selectedMedicineIds.remove(drugId);
      } else {
        selectedMedicineIds.add(drugId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          widget.isEditing ? "Edit Alarm" : "New Alarm",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
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
            const SizedBox(height: 15),
            availableDrugs.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "No drugs added to this patient profile.",
                        style: TextStyle(color: Colors.white24),
                      ),
                    ),
                  )
                : Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: availableDrugs.map((drug) {
                      final drugId = drugIdentifier(drug);
                      final isSelected = selectedMedicineIds.contains(drugId);
                      return GestureDetector(
                        onTap: () => _toggleMedicineSelection(drugId),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFBB86FC)
                                : const Color(0xFF1A1C1E),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFBB86FC)
                                  : Colors.white10,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFBB86FC,
                                      ).withOpacity(0.3),
                                      blurRadius: 8,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.add_circle_outline,
                                size: 20,
                                color: isSelected
                                    ? Colors.black
                                    : Colors.white38,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                drug['name'],
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
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
                  elevation: 5,
                ),
                onPressed: () {
                  final selectedDrugs = availableDrugs
                      .where(
                        (drug) =>
                            selectedMedicineIds.contains(drugIdentifier(drug)),
                      )
                      .toList();

                  Navigator.pop(context, {
                    "time":
                        "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')} $selectedPeriod",
                    "note": alarmNoteFromDrugs(selectedDrugs),
                    "snooze": snoozeMinutes,
                    "repeat": selectedRepeat,
                    "isActive": true,
                    "selectedDrugIds": selectedDrugs
                        .map(drugIdentifier)
                        .toList(),
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
      letterSpacing: 1.2,
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
                style: const TextStyle(color: Colors.white, fontSize: 22),
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
      onSelectedItemChanged: (i) {
        HapticFeedback.selectionClick();
        setState(() => selectedPeriod = i == 0 ? "AM" : "PM");
      },
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
