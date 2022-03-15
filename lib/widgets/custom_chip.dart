import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final String label;
  final Color color;
  CustomChip(this.label, {this.color: Colors.orangeAccent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
    );
  }
}
