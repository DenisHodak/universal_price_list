import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/universal_price_list_app_bar_widget.dart';
import '../widgets/universal_price_list_drawer_widget.dart';
import '../providers/users.dart';
import '../widgets/input_field_widget.dart';
import '../widgets/user_widget.dart';

class AllUsersScreen extends StatefulWidget {
  static const routeName = '/allusers';
  final String userRole;
  final String userName;
  const AllUsersScreen({Key? key, required this.userRole, required this.userName}) : super(key: key);

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  var _isLoading = false;
  var query = "";

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Users>(context, listen: false).getUsers().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  void _filterUsers(String searchValue) {
    setState(() {
      query = searchValue.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final showUsers = Provider.of<Users>(context).users.where((element) => ("${element.firstName} ${element.lastName}").toLowerCase().contains(query)).toList();
    return Scaffold(
      appBar: UniversalPriceListAppBarWidget(appBarTitle: 'All Users'),
      drawer: UniversalPriceListDrawerWidget(
          userRole: widget.userRole,
          userName: widget.userName),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
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
          ),
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: InputField(
                  child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Search",
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.white),
                      labelStyle: TextStyle(color: Colors.white),
                      icon: Icon(Icons.search, color: Colors.yellow),
                    ),
                    onChanged: (value) {
                      _filterUsers(value);
                    },
                  ),
                ),
              ),
              showUsers.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: showUsers.length,
                        itemBuilder: (ctx, index) => UserWidget(
                            id: showUsers[index].id,
                            firstName: showUsers[index].firstName,
                            lastName: showUsers[index].lastName,
                            email: showUsers[index].email,
                            role: showUsers[index].role),
                      ),
                    )
                  : Text('No Data'),
            ],
          ),
        ],
      ),
    );
  }
}
