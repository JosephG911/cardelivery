import 'package:flutter/material.dart';
import '../globals.dart';

class Selected extends StatefulWidget {
  final List<Map<String, dynamic>> selectedDrugs;
  final VoidCallback onRefresh;
  const Selected({
    super.key,
    required this.selectedDrugs,
    required this.onRefresh,
  });

  @override
  State<Selected> createState() => _SelectedState();
}

class _SelectedState extends State<Selected> {
  void _deleteItem(int index) {
    setState(() {
      widget.selectedDrugs.removeAt(index);
      allDrugs = List.from(widget.selectedDrugs);
    });
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: widget.selectedDrugs.isEmpty
          ? const Center(
              child: Text(
                "No medications added",
                style: TextStyle(color: Colors.white24),
              ),
            )
          : ListView.builder(
              itemCount: widget.selectedDrugs.length,
              itemBuilder: (context, index) {
                final item = widget.selectedDrugs[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        item['image'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          width: 50,
                          height: 50,
                          color: Colors.white10,
                          child: const Icon(
                            Icons.medication,
                            color: Colors.white24,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      item['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: const Text(
                      "Scheduled for this alarm",
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_sweep_outlined,
                        color: Colors.redAccent,
                        size: 28,
                      ),
                      onPressed: () => _deleteItem(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
