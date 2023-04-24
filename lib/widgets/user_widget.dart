import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/users.dart';

class UserWidget extends StatefulWidget {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  String role;
  UserWidget({
    Key? key,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
  }) : super(key: key);

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  
  void _changeRole(userId) {
    if (widget.role == "User") {
      Provider.of<Users>(context, listen: false)
          .changeUserRole(userId, "Moderator")
          .then((value) => {
                setState(() {
                  widget.role = "Moderator";
                })
              });
    } else {
      Provider.of<Users>(context, listen: false)
          .changeUserRole(userId, "User")
          .then((value) => {
                setState(() {
                  widget.role = "User";
                })
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black45,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 5,
      child: ListTile(
        subtitle: Text(
          widget.email,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        trailing: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.role,
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(width: 10),
                widget.role == "Admin"
                    ? Container()
                    : ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.yellow),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                        ),
                        onPressed: () {
                          _changeRole(widget.id);
                        },
                        child: widget.role == "User"
                            ? const Text('Promote')
                            : const Text('Demote'),
                      ),
              ],
            ),
          ),
        ),
        title: Text(
          '${widget.firstName} ${widget.lastName}',
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
