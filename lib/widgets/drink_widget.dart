import 'package:flutter/material.dart';

class DrinkWidget extends StatelessWidget {
  final String id;
  final String name;
  final double price;
  const DrinkWidget(
      {Key? key, required this.id, required this.name, required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black45,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 5,
      child: ListTile(
        trailing: Padding(
          padding: const EdgeInsets.all(10.0),
            child: FittedBox(
                child: Text(
              '$price€',
              style: const TextStyle(
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            )),
          ),
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            letterSpacing: 0.4,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
