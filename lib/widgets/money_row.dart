import 'package:flutter/material.dart';

class MoneyRow extends StatelessWidget {
  const MoneyRow(
      {super.key,
      required this.textTitle,
      required this.value,
      required this.color});

  final String textTitle;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$textTitle:",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            "\$ $value",
            style: TextStyle(
              fontSize: 25,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
