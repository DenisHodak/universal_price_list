import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/universal_price_list_app_bar_widget.dart';

import '../providers/bar.dart';
import '../providers/drink.dart';
import '../providers/drinks.dart';
import '../widgets/input_field_widget.dart';
import '../widgets/drink_widget.dart';
import '../widgets/add_drink_widget.dart';
import '../widgets/edit_drink_widget.dart';

class PriceListScreen extends StatefulWidget {
  final String barId;
  final String barName;
  final bool viewOnly;
  const PriceListScreen(
      {Key? key,
      required this.barId,
      required this.barName,
      required this.viewOnly})
      : super(key: key);

  @override
  State<PriceListScreen> createState() => _PriceListScreenState();
}

class _PriceListScreenState extends State<PriceListScreen> {
  String query = "";
  var _isLoading = false;

  List<Drink> showDrinks = [];

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Drinks>(context, listen: false)
        .getAllDrinks(widget.barId)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  _filterDrinks(String searchValue) {
    setState(() {
      query = searchValue.toLowerCase();
    });
  }

  void _openAddDrinkForm() {
    showDialog(
      context: context,
      builder: (context) => AddDrinkWidget(barId: widget.barId),
    );
  }

  void _openEditDrinkForm(String drinkId, String drinkName, double drinkPrice) {
    showDialog(
      context: context,
      builder: (context) => EditDrinkWidget(
          drinkId: drinkId, drinkName: drinkName, drinkPrice: drinkPrice),
    );
  }

  @override
  Widget build(BuildContext context) {
    showDrinks = Provider.of<Drinks>(context)
        .drinks
        .where((element) => element.title.toLowerCase().contains(query))
        .toList();
    showDrinks
        .sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    return Scaffold(
      appBar: UniversalPriceListAppBarWidget(appBarTitle: widget.barName),
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
                            _filterDrinks(value);
                          },
                        ),
                      ),
                    ),
                    showDrinks.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: showDrinks.length,
                              itemBuilder: (ctx, index) => GestureDetector(
                                child: DrinkWidget(
                                  id: showDrinks[index].id,
                                  name: showDrinks[index].title,
                                  price: showDrinks[index].price,
                                ),
                                onTap: () {
                                  if (!widget.viewOnly) {
                                    _openEditDrinkForm(
                                        showDrinks[index].id,
                                        showDrinks[index].title,
                                        showDrinks[index].price);
                                  }
                                },
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
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: widget.viewOnly
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Colors.amber,
              onPressed: () {
                _openAddDrinkForm();
              },
            ),
    );
  }
}
