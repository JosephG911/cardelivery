library my_project.globals;
int selectedPatientIndex = 0;
List<Map<String, dynamic>> allDrugs = [];
Map<String, int> persistentStock = {};

String drugIdentifier(Map<String, dynamic> drug) {
  final dynamic rawId =
      drug['id'] ?? drug['drugId'] ?? drug['drug_id'] ?? drug['ID'];

  if (rawId != null && rawId.toString().trim().isNotEmpty) {
    return rawId.toString();
  }

  return drug['name'].toString();
}

String alarmNoteFromDrugs(List<Map<String, dynamic>> drugs) {
  if (drugs.isEmpty) {
    return "Medicine";
  }

  return drugs
      .map((drug) => drug['name']?.toString() ?? '')
      .where((name) => name.isNotEmpty)
      .join(', ');
}

List<Map<String, dynamic>> patients = <Map<String, dynamic>>[];
