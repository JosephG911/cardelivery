import 'dart:convert';

import 'package:blearn/Pages/cart.dart';
import 'package:blearn/Pages/inventory.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../globals.dart';

Future<List<Map<String, dynamic>>> fetchDrugNames() async {
  final url = Uri.parse(
    'https://raw.githubusercontent.com/JosephG911/drugs-data/refs/heads/main/drugs.json',
  );
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    return List<Map<String, dynamic>>.from(jsonData['drugs']);
  }
  throw Exception('Failed to load drugs');
}

class MainPage extends StatefulWidget {
  final List<Map<String, dynamic>> patientDrugs;
  final Future<void> Function() onRefresh;

  const MainPage({
    super.key,
    required this.patientDrugs,
    required this.onRefresh,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  Future<bool> _handleExit() async {
    await widget.onRefresh();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleExit,
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: [
            DrugListPage(selectedDrugs: widget.patientDrugs),
            const InventoryPage(),
            Selected(selectedDrugs: widget.patientDrugs),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: const Color(0xFFBB86FC),
          unselectedItemColor: Colors.white54,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => setState(() => currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2),
              label: 'Stock',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.alarm),
              label: 'Alarm List',
            ),
          ],
        ),
      ),
    );
  }
}

class DrugListPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedDrugs;

  const DrugListPage({super.key, required this.selectedDrugs});

  @override
  State<DrugListPage> createState() => _DrugListPageState();
}

class _DrugListPageState extends State<DrugListPage> {
  List<Map<String, dynamic>> _displayDrugs = [];
  List<Map<String, dynamic>> _allFetchedDrugs = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDrugNames().then((drugs) {
      if (!mounted) return;
      setState(() {
        _allFetchedDrugs = drugs;
        _displayDrugs = drugs;
        _isLoading = false;
      });
    });
  }

  void _toggleStock(String drugName) {
    setState(() {
      if (persistentStock.containsKey(drugName)) {
        persistentStock.remove(drugName);
      } else {
        persistentStock[drugName] = 1;
      }
    });
  }

  void _toggleAlarm(Map<String, dynamic> drug) {
    setState(() {
      final selectedDrugId = drugIdentifier(drug);
      final index = widget.selectedDrugs.indexWhere(
        (e) => drugIdentifier(e) == selectedDrugId,
      );

      if (index == -1) {
        widget.selectedDrugs.add({...drug, 'count': 1});
      } else {
        widget.selectedDrugs.removeAt(index);
      }

      allDrugs = List<Map<String, dynamic>>.from(widget.selectedDrugs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFBB86FC)),
            )
          : Column(
              children: [
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) => setState(
                      () => _displayDrugs = _allFetchedDrugs
                          .where(
                            (drug) => drug['name'].toLowerCase().contains(
                              value.toLowerCase(),
                            ),
                          )
                          .toList(),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search drugs...',
                      filled: true,
                      fillColor: Colors.grey[900],
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFFBB86FC),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _displayDrugs.length,
                    itemBuilder: (context, index) {
                      final drug = _displayDrugs[index];
                      final currentDrugId = drugIdentifier(drug);
                      final isSelected = widget.selectedDrugs.any(
                        (e) => drugIdentifier(e) == currentDrugId,
                      );
                      final inStock = persistentStock.containsKey(drug['name']);

                      return ListTile(
                        leading: Image.asset(
                          drug['image'],
                          width: 40,
                          errorBuilder: (c, e, s) =>
                              const Icon(Icons.medication),
                        ),
                        title: Text(
                          drug['name'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                inStock
                                    ? Icons.inventory
                                    : Icons.add_box_outlined,
                                color: Colors.orangeAccent,
                              ),
                              onPressed: () => _toggleStock(drug['name']),
                            ),
                            IconButton(
                              icon: Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.add_circle_outline,
                                color: isSelected
                                    ? Colors.green
                                    : const Color(0xFFBB86FC),
                              ),
                              onPressed: () => _toggleAlarm(drug),
                            ),
                          ],
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
