import 'package:flutter/material.dart';

class Selected extends StatelessWidget {
  final List<Map<String, dynamic>> drugs;

  Selected({required this.drugs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: drugs.isEmpty
          ? Center(
              child: Text(
                "No drugs added",
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: drugs.length,
              itemBuilder: (context, index) {
                final drug = drugs[index];

                return ListTile(
                  leading: Image.asset(drug['image'], width: 40),
                  title: Text(
                    drug['name'],
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Text(
                    "x${drug['count'] ?? 0}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
