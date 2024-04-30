import 'package:flutter/material.dart';

class ShowPage3 extends StatelessWidget {
  const ShowPage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade300,
      ),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        height: 280,
        child: Center(
          child: Text(
            "ขก.แล้วแมร่ง",
            style: TextStyle(color: Colors.indigo),
          ),
        ),
      ),
    );
  }
}
