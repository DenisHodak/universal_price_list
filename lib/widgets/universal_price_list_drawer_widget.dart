import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authorization.dart';
import '../screens/sign_in_sign_up_screen.dart';

class UniversalPriceListDrawerWidget extends StatelessWidget {
  final String userRole;
  final String userName;
  const UniversalPriceListDrawerWidget(
      {Key? key, required this.userRole, required this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(210, 82, 77, 75).withOpacity(0.5),
              const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: Text("Hello, $userName!"),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.amber,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.coffee,
                color: Colors.amber,
              ),
              title: const Text(
                'All Bars',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => Navigator.of(context).pushReplacementNamed('/bars'),
            ),
            const Divider(),
            userRole == "Admin"
                ? ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Colors.amber,
                    ),
                    title: const Text(
                      'All users',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () =>
                        Navigator.of(context).pushReplacementNamed('/allusers'),
                  )
                : Container(),
            userRole == "Admin" ? const Divider() : Container(),
            userRole != "User"
                ? ListTile(
                    leading: const Icon(
                      Icons.coffee,
                      color: Colors.amber,
                    ),
                    title: const Text(
                      'My Bars',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () =>
                        Navigator.of(context).pushReplacementNamed('/mybars'),
                  )
                : Container(),
            userRole != "User" ?  const Divider() : Container(),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.amber,
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Provider.of<Authorization>(context, listen: false).logout();
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
