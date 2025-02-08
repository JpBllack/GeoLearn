import 'package:flutter/material.dart';

class SquareWidget extends StatelessWidget {
  final String imagePath;
  final String routeName;
  final String name;
  final Widget destination;

  const SquareWidget({
    super.key,
    required this.imagePath,
    required this.routeName,
    required this.name,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Padding (
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          },
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )
      ],
    ));
  }
}
