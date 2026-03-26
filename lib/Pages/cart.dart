import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> drugs;

  CartPage({required this.drugs});

  int getTotalCount() {
    int total = 0;
    for (var drug in drugs) {
      int count = 0;
      if (drug.containsKey('count')) {
        count = int.tryParse(drug['count'].toString()) ?? 0;
      }
      total += count;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text("Selected Drugs"),
        centerTitle: true,
        elevation: 0,
      ),
      body: drugs.isEmpty
          ? Center(
              child: Text(
                "No drugs added",
                style: TextStyle(color: Colors.white),
              ),
            )
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.grey[850],
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "Total Items: ${getTotalCount()}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: drugs.length,
                    itemBuilder: (context, index) {
                      final drug = drugs[index];
                      return Card(
                        color: Colors.grey[900],
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
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
                          subtitle: Text(
                            "Quantity: ${drug['count'] ?? 0}",
                            style: TextStyle(color: Colors.white70),
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
