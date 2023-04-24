import 'package:flutter/material.dart';

class UniversalPriceListAppBarWidget extends StatelessWidget
    with PreferredSizeWidget {
  final String appBarTitle;
  const UniversalPriceListAppBarWidget({Key? key, required this.appBarTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 255, 191, 0).withOpacity(0.5),
              const Color.fromARGB(255, 209, 6, 199).withOpacity(0.9),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
      title: Text(
        appBarTitle,
        style: const TextStyle(
          fontFamily: 'Pacifico',
          fontSize: 27,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
