import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final IconData icon;
  final Widget i;
  final String name;
  const CustomCard({
    super.key,
    required this.icon,
    required this.i,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Color.fromARGB(255, 83, 83, 83),
      color: Color.fromARGB(255, 45, 45, 45),

      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),

        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => i));
        },
        child: Container(
          width: 150,
          height: 100,
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Color(0xFFBB86FC), size: 32),
              SizedBox(height: 8),
              Text(
                name,
                style: TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
