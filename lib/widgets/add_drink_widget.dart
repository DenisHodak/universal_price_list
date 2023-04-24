import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/drinks.dart';

import './input_field_widget.dart';

class AddDrinkWidget extends StatefulWidget {
  final String barId;
  const AddDrinkWidget({Key? key, required this.barId}) : super(key: key);

  @override
  State<AddDrinkWidget> createState() => _AddDrinkWidgetState();
}

class _AddDrinkWidgetState extends State<AddDrinkWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String drinkName = "";
  double drinkPrice = 0;

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    Provider.of<Drinks>(context, listen: false)
        .addDrink(drinkName, drinkPrice, widget.barId)
        .then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      backgroundColor: Colors.black54,
      title: const Text('Add new drink',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.yellow,
          )),
      content: Container(
        height: 250,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                InputField(
                  child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Name of drink',
                      hintStyle: TextStyle(color: Colors.white),
                      icon: Icon(Icons.coffee, color: Colors.yellow),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Name can't be empty";
                      }
                    },
                    onSaved: (value) {
                      drinkName = value!;
                    },
                  ),
                ),
                InputField(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Price of drink',
                      hintStyle: TextStyle(color: Colors.white),
                      icon: Icon(Icons.coffee, color: Colors.yellow),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Price can't be empty";
                      }
                    },
                    onSaved: (value) {
                      drinkPrice = double.parse(value!);
                    },
                  ),
                ),
                const Divider(),
                SizedBox(
                  height: 25,
                  width: 120,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.yellow),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                    ),
                    onPressed: () => _save(),
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
