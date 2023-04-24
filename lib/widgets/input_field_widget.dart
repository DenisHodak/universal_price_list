import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final Widget child;
  const InputField({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(210, 82, 77, 75).withOpacity(0.7),
            const Color.fromARGB(255, 0, 0, 0).withOpacity(1),
          ],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: child,
    );
  }
}