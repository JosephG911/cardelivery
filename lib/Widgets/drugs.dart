import 'package:flutter/material.dart';
import 'package:blearn/Pages/cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchDrugNames() async {
  final url = Uri.parse(
    'https://raw.githubusercontent.com/JosephG911/drugs-data/main/drugs.json',
  );
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    return List<Map<String, dynamic>>.from(jsonData['drugs']);
  } else {
    throw Exception('Failed to load drug names');
  }
}

class MainPage extends StatefulWidget {
  final List<Map<String, dynamic>> patientDrugs;
  final VoidCallback onRefresh;

  MainPage({required this.patientDrugs, required this.onRefresh});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  void updateCart(Map<String, dynamic> drug, int change) {
    setState(() {
      int index = widget.patientDrugs.indexWhere(
        (element) => element['name'] == drug['name'],
      );

      if (index != -1) {
        widget.patientDrugs[index]['count'] =
            (widget.patientDrugs[index]['count'] ?? 0) + change;
        if (widget.patientDrugs[index]['count'] <= 0) {
          widget.patientDrugs.removeAt(index);
        }
      } else if (change > 0) {
        var newDrug = Map<String, dynamic>.from(drug);
        newDrug['count'] = 1;
        widget.patientDrugs.add(newDrug);
      }
    });
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentIndex == 0
          ? DrugListPage(
              selectedDrugs: widget.patientDrugs,
              onUpdate: (drug, change) => updateCart(drug, change),
            )
          : Selected(drugs: widget.patientDrugs),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        selectedItemColor: Color(0xFFBB86FC),
        unselectedItemColor: Colors.white54,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.medication), label: "Drugs"),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_sharp),
            label: "Selected",
          ),
        ],
      ),
    );
  }
}

class DrugListPage extends StatefulWidget {
  final Function(Map<String, dynamic>, int) onUpdate;
  final List<Map<String, dynamic>> selectedDrugs;

  DrugListPage({required this.onUpdate, required this.selectedDrugs});

  @override
  _DrugListPageState createState() => _DrugListPageState();
}

class _DrugListPageState extends State<DrugListPage> {
  List<Map<String, dynamic>> _allDrugs = [];
  List<Map<String, dynamic>> _filteredDrugs = [];
  bool _isLoading = true;
  Map<int, bool> expanded = {};

  @override
  void initState() {
    super.initState();
    fetchDrugNames().then((drugs) {
      setState(() {
        _allDrugs = drugs;
        _filteredDrugs = drugs;
        _isLoading = false;
      });
    });
  }

  void _filterDrugs(String query) {
    final filtered = _allDrugs.where((drug) {
      return drug['name'].toString().toLowerCase().contains(
        query.toLowerCase(),
      );
    }).toList();
    setState(() {
      _filteredDrugs = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFFBB86FC)))
          : Column(
              children: [
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    onChanged: _filterDrugs,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search drugs for current ID...",
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.grey[850],
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: _filteredDrugs.length,
                    itemBuilder: (context, index) {
                      final drug = _filteredDrugs[index];
                      final isOpen = expanded[index] ?? false;

                      final cartItem = widget.selectedDrugs.firstWhere(
                        (element) => element['name'] == drug['name'],
                        orElse: () => {},
                      );
                      int currentCount = cartItem.isNotEmpty
                          ? (cartItem['count'] ?? 0)
                          : 0;

                      return Card(
                        color: Colors.grey[900],
                        margin: EdgeInsets.all(6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              expanded[index] = !isOpen;
                            });
                          },
                          child: Column(
                            children: [
                              ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    drug['image'],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  drug['name'],
                                  style: TextStyle(color: Colors.white),
                                ),
                                trailing: Icon(
                                  isOpen
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  color: Color(0xFFBB86FC),
                                ),
                              ),
                              if (isOpen)
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () =>
                                                widget.onUpdate(drug, 1),
                                            icon: Icon(
                                              Icons.add_circle,
                                              color: Color(0xFFBB86FC),
                                            ),
                                          ),
                                          Text(
                                            currentCount.toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              if (currentCount > 0)
                                                widget.onUpdate(drug, -1);
                                            },
                                            icon: Icon(
                                              Icons.remove_circle,
                                              color: Colors.white54,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        drug['description'] ?? 'No description',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
