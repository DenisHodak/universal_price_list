import 'package:flutter/material.dart';

import '../widgets/universal_price_list_drawer_widget.dart';
import '../widgets/universal_price_list_app_bar_widget.dart';
import '../widgets/bar_widget.dart';
import 'package:provider/provider.dart';

import '../screens/add_bar_screen.dart';

import '../providers/bar.dart';
import '../providers/bars.dart';

class MyBarsScreen extends StatefulWidget {
  static const routeName = '/mybars';
  final String ownerId;
  final String userRole;
  final String userName;
  MyBarsScreen({Key? key, required this.ownerId, required this.userRole, required this.userName}) : super(key: key);

  @override
  State<MyBarsScreen> createState() => _MyBarsScreenState();
}

class _MyBarsScreenState extends State<MyBarsScreen> {
  List<Bar> showBars = [];
  var _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Bars>(context, listen: false).getMyBars(widget.ownerId).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final showBars = Provider.of<Bars>(context, listen: true).myBars;
    showBars.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const UniversalPriceListAppBarWidget(appBarTitle: 'My Bars'),
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
                                viewOnly: false,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: 10 / 5,
                                mainAxisSpacing: 10,
                              ),
                            ),
                          )
                        : Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: Colors.transparent),
                              width: double.infinity,
                              child: const Text(
                                "You didn't provide any Bar data",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: Colors.amber,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10, top: 10),
                        height: 45,
                        width: size.width * 0.8,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.amber),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) =>
                                    AddBarScreen(ownerId: widget.ownerId)));
                          },
                          child: const Text(
                            'Add Your Bar',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ],
      ),
    );
  }
}
