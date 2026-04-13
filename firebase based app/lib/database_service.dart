import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _patientsCollection =>
      _db.collection('users').doc(uid).collection('patients');

  // 1. إضافة مريض جديد
  Future<void> addPatient(String name, String patientId) async {
    await _patientsCollection.doc(patientId).set({
      'name': name,
      'id': patientId,
      'selectedDrugs': <Map<String, dynamic>>[],
      'alarms': <Map<String, dynamic>>[],
      'stock': <String, int>{},
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // 2. جلب مرضى المستخدم (Real-time)
  Stream<List<Map<String, dynamic>>> getPatients() {
    return _patientsCollection
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': data['id'] ?? doc.id,
              'name': data['name'] ?? 'Unknown',
              'selectedDrugs': List<Map<String, dynamic>>.from(
                data['selectedDrugs'] ?? [],
              ),
              'alarms': List<Map<String, dynamic>>.from(data['alarms'] ?? []),
              'stock': Map<String, int>.from(data['stock'] ?? {}),
            };
          }).toList(),
        );
  }

  // 3. التحديث الشامل (السر في حل مشكلتك)
  // جعلنا المعاملات اختيارية (Optional) باستخدام {} لسهولة الاستدعاء
  Future<void> updatePatientData(
    String patientId, {
    List? drugs,
    List? alarms,
    Map<String, int>? stock,
  }) async {
    final Map<String, dynamic> dataToUpdate = {};

    if (drugs != null) dataToUpdate['selectedDrugs'] = drugs;
    if (alarms != null) dataToUpdate['alarms'] = alarms;
    if (stock != null) dataToUpdate['stock'] = stock;

    if (dataToUpdate.isNotEmpty) {
      await _patientsCollection
          .doc(patientId)
          .set(dataToUpdate, SetOptions(merge: true));
    }
  }

  // 4. حذف مريض
  Future<void> deletePatient(String patientId) async {
    await _patientsCollection.doc(patientId).delete();
  }
}
