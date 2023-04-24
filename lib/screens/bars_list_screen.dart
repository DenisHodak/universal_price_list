import 'package:flutter/material.dart';

import '../widgets/universal_price_list_drawer_widget.dart';
import '../providers/bar.dart';
import '../widgets/bar_widget.dart';
import '../widgets/input_field_widget.dart';
import '../widgets/universal_price_list_app_bar_widget.dart';

import 'package:provider/provider.dart';
import '../providers/bars.dart';

class BarsListScreen extends StatefulWidget {
  static const routeName = '/bars';
  final String userName;
  final String userRole;
  const BarsListScreen({Key? key, required this.userName, required this.userRole}) : super(key: key);

  @override
  State<BarsListScreen> createState() => _BarsListScreenState();
}

class _BarsListScreenState extends State<BarsListScreen> {
  List<Bar> showBars = [];
  var _isLoading = false;
  String query = "";

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Bars>(context, listen: false).getAllBars().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  _filterBars(String searchValue) {
    setState(() {
      query = searchValue.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    showBars = Provider.of<Bars>(context, listen: false)
        .bars
        .where((element) =>
            element.name.toLowerCase().contains(query) ||
            element.location.toLowerCase().contains(query))
        .toList();
        showBars.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return Scaffold(
      appBar: const UniversalPriceListAppBarWidget(
          appBarTitle: 'Universal Price List'),
      drawer: UniversalPriceListDrawerWidget(userRole: widget.userRole, userName: widget.userName),
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
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
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
                            _filterBars(value);
                          },
                        ),
                      ),
                    ),
                    showBars.isNotEmpty
                        ? Expanded(
                            child: GridView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: showBars.length,
                              itemBuilder: (ctx, index) => BarWidget(
                                id: showBars[index].id,
                                name: showBars[index].name,
                                location: showBars[index].location,
                                image: showBars[index].image,
                                viewOnly: true,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: 2 / 1,
                                mainAxisSpacing: 10,
                              ),
                            ),
                          )
                        : const Text(
                            "No data",
                            textAlign: TextAlign.center,
                          ),
                  ],
                ),
        ],
      ),
    );
  }
}
