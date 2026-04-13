//todo:basic

// import 'package:flutter/material.dart';
// import '../globals.dart';

// class SetAlarm extends StatefulWidget {
//   final VoidCallback? onRefresh;

//   const SetAlarm({super.key, this.onRefresh});

//   @override
//   State<SetAlarm> createState() => _SetAlarmState();
// }

// class _SetAlarmState extends State<SetAlarm> {
//   TimeOfDay selectedTime = TimeOfDay.now();
//   TextEditingController noteController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final currentPatient = patients[selectedPatientIndex];

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: Text(
//           "Set Alarm",
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         backgroundColor: Colors.black,
//         elevation: 0,
//         iconTheme: IconThemeData(color: Color(0xFFBB86FC)),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.grey[900],
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.grey[800]!),
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Selected Time",
//                             style: TextStyle(
//                               color: Colors.white54,
//                               fontSize: 14,
//                             ),
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             selectedTime.format(context),
//                             style: TextStyle(
//                               color: Color(0xFFBB86FC),
//                               fontSize: 32,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       ElevatedButton(
//                         onPressed: () async {
//                           TimeOfDay? picked = await showTimePicker(
//                             context: context,
//                             initialTime: selectedTime,
//                             builder: (context, child) {
//                               return Theme(
//                                 data: ThemeData.dark().copyWith(
//                                   colorScheme: ColorScheme.dark(
//                                     primary: Color(0xFFBB86FC),
//                                     onPrimary: Colors.black,
//                                     surface: Colors.grey[900]!,
//                                   ),
//                                 ),
//                                 child: child!,
//                               );
//                             },
//                           );
//                           if (picked != null)
//                             setState(() => selectedTime = picked);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFFBB86FC),
//                           foregroundColor: Colors.black,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: Text("Change"),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   TextField(
//                     controller: noteController,
//                     style: TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       hintText: "Medicine name or note...",
//                       hintStyle: TextStyle(color: Colors.white24),
//                       filled: true,
//                       fillColor: Colors.black,
//                       prefixIcon: Icon(
//                         Icons.edit,
//                         color: Colors.white54,
//                         size: 20,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                         borderSide: BorderSide(color: Colors.grey[800]!),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                         borderSide: BorderSide(color: Colors.grey[800]!),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton.icon(
//                       onPressed: () {
//                         if (noteController.text.trim().isEmpty) return;
//                         setState(() {
//                           currentPatient['alarms'].add({
//                             "time": selectedTime.format(context),
//                             "note": noteController.text.trim(),
//                           });
//                         });
//                         if (widget.onRefresh != null) widget.onRefresh!();

//                         noteController.clear();
//                         FocusScope.of(context).unfocus();
//                       },
//                       icon: Icon(Icons.alarm_add),
//                       label: Text(
//                         "Add Alarm",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         foregroundColor: Colors.black,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(height: 30),

//             Row(
//               children: [
//                 Icon(
//                   Icons.notifications_active,
//                   color: Color(0xFFBB86FC),
//                   size: 20,
//                 ),
//                 SizedBox(width: 8),
//                 Text(
//                   "Alarms for ${currentPatient['name']}",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 15),

//             Expanded(
//               child: currentPatient['alarms'].isEmpty
//                   ? Center(
//                       child: Text(
//                         "No alarms set",
//                         style: TextStyle(color: Colors.white30),
//                       ),
//                     )
//                   : ListView.builder(
//                       physics: BouncingScrollPhysics(),
//                       itemCount: currentPatient['alarms'].length,
//                       itemBuilder: (context, index) {
//                         var alarm = currentPatient['alarms'][index];
//                         return Container(
//                           margin: EdgeInsets.only(bottom: 12),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[900],
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: ListTile(
//                             leading: CircleAvatar(
//                               backgroundColor: Colors.black,
//                               child: Icon(
//                                 Icons.access_time,
//                                 color: Color(0xFFBB86FC),
//                               ),
//                             ),
//                             title: Text(
//                               alarm['time'],
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18,
//                               ),
//                             ),
//                             subtitle: Text(
//                               alarm['note'],
//                               style: TextStyle(color: Colors.white54),
//                             ),
//                             trailing: IconButton(
//                               icon: Icon(
//                                 Icons.delete_outline,
//                                 color: Colors.redAccent,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   currentPatient['alarms'].removeAt(index);
//                                 });
//                                 if (widget.onRefresh != null)
//                                   widget.onRefresh!();
//                               },
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//todo: proffitional ios

// import 'package:flutter/material.dart';
// import '../globals.dart';

// class SetAlarm extends StatefulWidget {
//   final VoidCallback? onRefresh;

//   const SetAlarm({super.key, this.onRefresh});

//   @override
//   State<SetAlarm> createState() => _SetAlarmState();
// }

// class _SetAlarmState extends State<SetAlarm> {
//   TimeOfDay selectedTime = TimeOfDay.now();
//   TextEditingController noteController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final currentPatient = patients[selectedPatientIndex];

//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0A0A),
//       appBar: AppBar(
//         title: const Text(
//           "Schedule Dose",
//           style: TextStyle(
//             fontWeight: FontWeight.w800,
//             fontSize: 24,
//             letterSpacing: 1.2,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Color(0xFFBB86FC)),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 10),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [const Color(0xFF1E1E1E), const Color(0xFF121212)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(32),
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFFBB86FC).withOpacity(0.1),
//                     blurRadius: 20,
//                     offset: const Offset(0, 10),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   GestureDetector(
//                     onTap: () async {
//                       TimeOfDay? picked = await showTimePicker(
//                         context: context,
//                         initialTime: selectedTime,
//                       );
//                       if (picked != null) setState(() => selectedTime = picked);
//                     },
//                     child: Column(
//                       children: [
//                         const Text(
//                           "TAP TO SET TIME",
//                           style: TextStyle(
//                             color: Colors.white30,
//                             fontSize: 12,
//                             letterSpacing: 2,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           selectedTime.format(context),
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 64,
//                             fontWeight:
//                                 FontWeight.w200, // خط رفيع للمظهر العصري
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: noteController,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       hintText: "What medication?",
//                       hintStyle: const TextStyle(color: Colors.white24),
//                       filled: true,
//                       fillColor: Colors.black38,
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 18,
//                       ),
//                       prefixIcon: const Icon(
//                         Icons.medication_liquid,
//                         color: Color(0xFFBB86FC),
//                         size: 22,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 55,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (noteController.text.trim().isEmpty) return;
//                         setState(() {
//                           currentPatient['alarms'].add({
//                             "time": selectedTime.format(context),
//                             "note": noteController.text.trim(),
//                           });
//                         });
//                         if (widget.onRefresh != null) widget.onRefresh!();
//                         noteController.clear();
//                         FocusScope.of(context).unfocus();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFBB86FC),
//                         foregroundColor: Colors.black,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: const Text(
//                         "Create Alarm",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 40),

//             const Text(
//               "UPCOMING DOSES",
//               style: TextStyle(
//                 color: Colors.white30,
//                 fontSize: 12,
//                 letterSpacing: 1.5,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 15),

//             Expanded(
//               child: currentPatient['alarms'].isEmpty
//                   ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.alarm_off,
//                             color: Colors.white10,
//                             size: 80,
//                           ),
//                           const SizedBox(height: 10),
//                           const Text(
//                             "No alarms scheduled",
//                             style: TextStyle(color: Colors.white24),
//                           ),
//                         ],
//                       ),
//                     )
//                   : ListView.builder(
//                       physics: const BouncingScrollPhysics(),
//                       itemCount: currentPatient['alarms'].length,
//                       itemBuilder: (context, index) {
//                         var alarm = currentPatient['alarms'][index];
//                         return Container(
//                           margin: const EdgeInsets.only(bottom: 16),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF1A1A1A),
//                             borderRadius: BorderRadius.circular(24),
//                           ),
//                           child: ListTile(
//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 8,
//                             ),
//                             title: Text(
//                               alarm['time'],
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             subtitle: Text(
//                               alarm['note'],
//                               style: const TextStyle(
//                                 color: Color(0xFFBB86FC),
//                                 fontSize: 14,
//                               ),
//                             ),
//                             trailing: IconButton(
//                               icon: Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.redAccent.withOpacity(0.1),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: const Icon(
//                                   Icons.delete_outline,
//                                   color: Colors.redAccent,
//                                   size: 20,
//                                 ),
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   currentPatient['alarms'].removeAt(index);
//                                 });
//                                 if (widget.onRefresh != null)
//                                   widget.onRefresh!();
//                               },
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//todo: simple one

// import 'package:flutter/material.dart';
// import '../globals.dart';

// class SetAlarm extends StatefulWidget {
//   final VoidCallback? onRefresh;

//   const SetAlarm({super.key, this.onRefresh});

//   @override
//   State<SetAlarm> createState() => _SetAlarmState();
// }

// class _SetAlarmState extends State<SetAlarm> {
//   TimeOfDay selectedTime = TimeOfDay.now();
//   TextEditingController noteController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final currentPatient = patients[selectedPatientIndex];

//     return Scaffold(
//       backgroundColor: const Color(0xFF121212),
//       appBar: AppBar(
//         title: const Text("Set Reminder"),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           children: [
//             const SizedBox(height: 10),

//             Container(
//               padding: const EdgeInsets.all(25),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1E1E1E),
//                 borderRadius: BorderRadius.circular(40),
//                 border: Border.all(
//                   color: const Color(0xFFBB86FC).withOpacity(0.3),
//                   width: 2,
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   Text(
//                     "Set Time",
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.6),
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 15),

//                   GestureDetector(
//                     onTap: () async {
//                       TimeOfDay? picked = await showTimePicker(
//                         context: context,
//                         initialTime: selectedTime,
//                       );
//                       if (picked != null) setState(() => selectedTime = picked);
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 30,
//                         vertical: 10,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.black26,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         selectedTime.format(context),
//                         style: const TextStyle(
//                           color: Color(0xFFBB86FC),
//                           fontSize: 50,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 25),

//                   TextField(
//                     controller: noteController,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       hintText: "Add a note",
//                       hintStyle: const TextStyle(color: Colors.white24),
//                       filled: true,
//                       fillColor: Colors.black,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         borderSide: BorderSide.none,
//                       ),
//                       prefixIcon: const Icon(
//                         Icons.edit_note,
//                         color: Color(0xFFBB86FC),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   SizedBox(
//                     width: double.infinity,
//                     height: 60,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           currentPatient['alarms'].add({
//                             "time": selectedTime.format(context),
//                             "note": noteController.text.trim().isEmpty
//                                 ? "No description"
//                                 : noteController.text.trim(),
//                           });
//                         });

//                         if (widget.onRefresh != null) widget.onRefresh!();

//                         noteController.clear();
//                         FocusScope.of(context).unfocus();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFBB86FC),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                       ),
//                       child: const Text(
//                         "Add An Alarm",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 30),

//             const Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "  Setted Alarms",
//                 style: TextStyle(color: Colors.white70, fontSize: 18),
//               ),
//             ),

//             const SizedBox(height: 15),

//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: currentPatient['alarms'].length,
//               itemBuilder: (context, index) {
//                 var alarm = currentPatient['alarms'][index];
//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 15),
//                   padding: const EdgeInsets.all(5),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.05),
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   child: ListTile(
//                     title: Text(
//                       alarm['time'],
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     subtitle: Text(
//                       alarm['note'],
//                       style: const TextStyle(color: Colors.white38),
//                     ),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.close, color: Colors.redAccent),
//                       onPressed: () {
//                         setState(() {
//                           currentPatient['alarms'].removeAt(index);
//                         });
//                         if (widget.onRefresh != null) widget.onRefresh!();
//                       },
//                     ),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 50),
//           ],
//         ),
//       ),
//     );
//   }
// }

//todo:custom picker

// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import '../globals.dart';

// class SetAlarm extends StatefulWidget {
//   final VoidCallback? onRefresh;
//   const SetAlarm({super.key, this.onRefresh});

//   @override
//   State<SetAlarm> createState() => _SetAlarmState();
// }

// class _SetAlarmState extends State<SetAlarm> {

//   late int selectedHour;
//   late int selectedMinute;
//   TextEditingController noteController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     selectedHour = DateTime.now().hour;
//     selectedMinute = DateTime.now().minute;
//   }

//   void _showAddAlarmSheet(BuildContext context) {

//     selectedHour = DateTime.now().hour;
//     selectedMinute = DateTime.now().minute;

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: const Color(0xFF141414),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//             left: 25,
//             right: 25,
//             top: 15,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [

//               Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.white10,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               const SizedBox(height: 25),

//               const Text(
//                 "Set Reminder Time",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//               const SizedBox(height: 30),

//               SizedBox(
//                 height: 180,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [

//                     Container(
//                       height: 45,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.03),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           child: _buildCalmPicker(
//                             0,
//                             23,
//                             selectedHour,
//                             (val) => selectedHour = val,
//                           ),
//                         ),
//                         const Text(
//                           ":",
//                           style: TextStyle(
//                             color: Color(0xFFBB86FC),
//                             fontSize: 28,
//                             fontWeight: FontWeight.w300,
//                           ),
//                         ),
//                         Expanded(
//                           child: _buildCalmPicker(
//                             0,
//                             59,
//                             selectedMinute,
//                             (val) => selectedMinute = val,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 30),

//               TextField(
//                 controller: noteController,
//                 style: const TextStyle(color: Colors.white, fontSize: 15),
//                 decoration: InputDecoration(
//                   hintText: "Add a quick note...",
//                   hintStyle: const TextStyle(color: Colors.white24),
//                   filled: true,
//                   fillColor: Colors.white.withOpacity(0.05),
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 15,
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(18),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 25),

//               SizedBox(
//                 width: double.infinity,
//                 height: 55,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     final currentPatient = patients[selectedPatientIndex];
//                     setState(() {
//                       currentPatient['alarms'].add({
//                         "time":
//                             "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}",
//                         "note": noteController.text.trim().isEmpty
//                             ? "Reminder"
//                             : noteController.text.trim(),
//                       });
//                     });
//                     if (widget.onRefresh != null) widget.onRefresh!();
//                     Navigator.pop(context);
//                     noteController.clear();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFBB86FC),
//                     foregroundColor: Colors.black,
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(18),
//                     ),
//                   ),
//                   child: const Text(
//                     "Save Reminder",
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildCalmPicker(
//     int min,
//     int max,
//     int initialValue,
//     Function(int) onSelected,
//   ) {
//     return CupertinoPicker(
//       scrollController: FixedExtentScrollController(initialItem: initialValue),
//       itemExtent: 45,
//       diameterRatio: 2.0,
//       magnification: 1.2,
//       useMagnifier: true,
//       onSelectedItemChanged: (index) {
//         HapticFeedback.selectionClick();
//         onSelected(min + index);
//       },
//       children: List.generate(max - min + 1, (index) {
//         return Center(
//           child: Text(
//             (min + index).toString().padLeft(2, '0'),
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 22,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentPatient = patients[selectedPatientIndex];

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text(
//           "Alarms",
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: currentPatient['alarms'].isEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.notifications_none,
//                     size: 60,
//                     color: Colors.white.withOpacity(0.1),
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     "No active alarms",
//                     style: TextStyle(color: Colors.white24),
//                   ),
//                 ],
//               ),
//             )
//           : ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               itemCount: currentPatient['alarms'].length,
//               itemBuilder: (context, index) {
//                 var alarm = currentPatient['alarms'][index];
//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF1A1A1A),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 5,
//                     ),
//                     title: Text(
//                       alarm['time'],
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     subtitle: Text(
//                       alarm['note'],
//                       style: const TextStyle(
//                         color: Color(0xFFBB86FC),
//                         fontSize: 14,
//                       ),
//                     ),
//                     trailing: IconButton(
//                       icon: const Icon(
//                         Icons.close,
//                         color: Colors.white24,
//                         size: 20,
//                       ),
//                       onPressed: () {
//                         setState(
//                           () => currentPatient['alarms'].removeAt(index),
//                         );
//                         if (widget.onRefresh != null) widget.onRefresh!();
//                       },
//                     ),
//                   ),
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddAlarmSheet(context),
//         backgroundColor: const Color(0xFFBB86FC),
//         elevation: 4,
//         child: const Icon(Icons.add, color: Colors.black, size: 28),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import '../globals.dart';
// import 'additional_settings.dart';

// class SetAlarm extends StatefulWidget {
//   final VoidCallback? onRefresh;
//   const SetAlarm({super.key, this.onRefresh});

//   @override
//   State<SetAlarm> createState() => _SetAlarmState();
// }

// class _SetAlarmState extends State<SetAlarm> {
//   int selectedHour = 12;
//   int selectedMinute = 0;
//   String selectedPeriod = "AM";

//   @override
//   Widget build(BuildContext context) {
//     final currentPatient = patients[selectedPatientIndex];
//     final List alarms = currentPatient['alarms'];

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text(
//           "Alarms",
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         backgroundColor: Colors.black,
//         elevation: 0,
//       ),
//       body: alarms.isEmpty
//           ? const Center(
//               child: Text(
//                 "No alarms setted yet",
//                 style: TextStyle(color: Colors.white24),
//               ),
//             )
//           : ListView.builder(
//               padding: const EdgeInsets.all(20),
//               itemCount: alarms.length,
//               itemBuilder: (context, index) {
//                 var alarm = alarms[index];
//                 bool isAct = alarm['isActive'] ?? true;
//                 return _buildAlarmTile(alarm, index, isAct, alarms);
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showQuickAdd(context),
//         backgroundColor: const Color(0xFFBB86FC),
//         child: const Icon(Icons.add, color: Colors.black, size: 30),
//       ),
//     );
//   }

//   Widget _buildAlarmTile(dynamic alarm, int index, bool isAct, List alarms) {
//     return GestureDetector(
//       onLongPress: () => _handleDelete(index),
//       onTap: () async {
//         List<String> parts = alarm['time'].split(':');
//         int h = int.parse(parts[0]);
//         int m = int.parse(parts[1].split(' ')[0]);
//         String p = parts[1].split(' ')[1];

//         final result = await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => AdditionalSettings(
//               initialHour: h,
//               initialMinute: m,
//               initialPeriod: p,
//               initialNote: alarm['note'],
//               initialSnooze: alarm['snooze'] ?? 5,
//               initialRepeat: alarm['repeat'] ?? "Once",
//               // isEditing: true,
//             ),
//           ),
//         );

//         if (result != null) {
//           setState(() => alarms[index] = result);
//           if (widget.onRefresh != null) widget.onRefresh!();
//         }
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 15),
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: const Color(0xFF1A1C1E),
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     alarm['time'],
//                     style: TextStyle(
//                       color: isAct ? Colors.white : Colors.white24,
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     "${alarm['note']} • ${alarm['repeat'] ?? 'Once'}",
//                     style: const TextStyle(color: Colors.white38, fontSize: 13),
//                   ),
//                 ],
//               ),
//             ),
//             CupertinoSwitch(
//               value: isAct,
//               activeColor: const Color(0xFFBB86FC),
//               onChanged: (v) {
//                 setState(() => alarm['isActive'] = v);
//                 if (widget.onRefresh != null) widget.onRefresh!();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showQuickAdd(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: const Color(0xFF1A1C1E),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
//       ),
//       builder: (context) => StatefulBuilder(
//         builder: (context, setModalState) => Padding(
//           padding: const EdgeInsets.all(30),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 "Set Alarm",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _scrollUnit(
//                     1,
//                     12,
//                     selectedHour,
//                     (v) => setModalState(() => selectedHour = v),
//                   ),
//                   const Text(
//                     ":",
//                     style: TextStyle(color: Colors.white24, fontSize: 30),
//                   ),
//                   _scrollUnit(
//                     0,
//                     59,
//                     selectedMinute,
//                     (v) => setModalState(() => selectedMinute = v),
//                   ),
//                   _ampmUnit(setModalState),
//                 ],
//               ),
//               const SizedBox(height: 30),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                       ),
//                       onPressed: () async {
//                         final res = await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => AdditionalSettings(
//                               initialHour: selectedHour,
//                               initialMinute: selectedMinute,
//                               initialPeriod: selectedPeriod,
//                               initialNote: "",
//                             ),
//                           ),
//                         );
//                         if (res != null) {
//                           setState(
//                             () => patients[selectedPatientIndex]['alarms'].add(
//                               res,
//                             ),
//                           );
//                           Navigator.pop(context);
//                           if (widget.onRefresh != null) widget.onRefresh!();
//                         }
//                       },
//                       child: const Text("Advanced"),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFBB86FC),
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                       ),
//                       onPressed: () {
//                         setState(
//                           () => patients[selectedPatientIndex]['alarms'].add({
//                             "time":
//                                 "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')} $selectedPeriod",
//                             "note": "Medicine",
//                             "isActive": true,
//                             "snooze": 5,
//                             "repeat": "Once",
//                           }),
//                         );
//                         Navigator.pop(context);
//                         if (widget.onRefresh != null) widget.onRefresh!();
//                       },
//                       child: const Text(
//                         "Save",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _scrollUnit(int min, int max, int init, Function(int) onSet) =>
//       SizedBox(
//         width: 70,
//         height: 120,
//         child: CupertinoPicker(
//           itemExtent: 40,
//           scrollController: FixedExtentScrollController(
//             initialItem: init - min,
//           ),
//           onSelectedItemChanged: onSet,
//           children: List.generate(
//             max - min + 1,
//             (i) => Center(
//               child: Text(
//                 "${min + i}",
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//         ),
//       );

//   Widget _ampmUnit(StateSetter set) => SizedBox(
//     width: 70,
//     height: 120,
//     child: CupertinoPicker(
//       itemExtent: 40,
//       onSelectedItemChanged: (i) =>
//           set(() => selectedPeriod = i == 0 ? "AM" : "PM"),
//       children: const [
//         Center(
//           child: Text("AM", style: TextStyle(color: Colors.white)),
//         ),
//         Center(
//           child: Text("PM", style: TextStyle(color: Colors.white)),
//         ),
//       ],
//     ),
//   );

//   void _handleDelete(int index) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: const Color(0xFF1A1C1E),
//         title: const Text(
//           "Delete Alarm",
//           style: TextStyle(color: Colors.white),
//         ),
//         content: Text(
//           "Want to delete this alarm ?",
//           style: TextStyle(color: Colors.white70),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () {
//               setState(
//                 () => patients[selectedPatientIndex]['alarms'].removeAt(index),
//               );
//               if (widget.onRefresh != null) widget.onRefresh!();
//               Navigator.pop(context);
//             },
//             child: const Text("Delete", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../globals.dart';
import 'additional_settings.dart';
import 'package:blearn/Widgets/drugs.dart'; // تأكد من استيراد صفحة البحث

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
              // فتح صفحة البحث لإضافة أدوية للمنبه القادم
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(
                    patientDrugs: allDrugs,
                    onRefresh: () => setState(() {}),
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

  // ... (باقي كود _buildAlarmTile و _handleDelete و _scrollUnit و _ampmUnit كما هو في كودك بالضبط بدون تغيير)

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
                ((alarm['selectedDrugIds'] as List?) ?? [])
                    .map((id) => id.toString()),
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
            List<Map<String, dynamic>>.from(updatedAlarm['selectedDrugs'] ?? []),
          );
          setState(() => alarms[index] = updatedAlarm);
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
                setState(() => alarm['isActive'] = v);
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
                          final selectedAlarmDrugs = List<Map<String, dynamic>>.from(
                            allDrugs,
                          );
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

  // ... (نفس دوال _scrollUnit و _ampmUnit و _handleDelete كما هي بالضبط في كودك)
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
