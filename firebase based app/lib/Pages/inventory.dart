import 'package:flutter/material.dart';
import '../globals.dart';

class InventoryPage extends StatefulWidget {
  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  Widget build(BuildContext context) {
    final stockItems = persistentStock.entries.toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: stockItems.isEmpty
          ? const Center(
              child: Text(
                "Inventory is empty.\nAdd items using the yellow button in Search.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white24),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: stockItems.length,
                    itemBuilder: (context, index) {
                      final entry = stockItems[index];
                      int stockValue = entry.value;
                      double progress = (stockValue / 20).clamp(0.0, 1.0);

                      return GestureDetector(
                        onLongPress: () {
                          setState(
                            () => persistentStock[entry.key] = stockValue + 5,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: stockValue < 3
                                  ? Colors.redAccent.withOpacity(0.3)
                                  : Colors.transparent,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.medication_liquid,
                                    color: Color(0xFFBB86FC),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      entry.key,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "$stockValue",
                                    style: TextStyle(
                                      color: stockValue < 3
                                          ? Colors.redAccent
                                          : Colors.greenAccent,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.white10,
                                color: stockValue < 3
                                    ? Colors.redAccent
                                    : const Color(0xFFBB86FC),
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.white38,
                                    ),
                                    onPressed: () => setState(
                                      () => persistentStock[entry.key] =
                                          (stockValue > 0) ? stockValue - 1 : 0,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      color: Color(0xFFBB86FC),
                                    ),
                                    onPressed: () => setState(
                                      () => persistentStock[entry.key] =
                                          stockValue + 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBB86FC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Inventory Levels Confirmed!"),
                          ),
                        );
                      },
                      child: const Text(
                        "CONFIRM STOCK",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
