import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/drinks.dart';

import './input_field_widget.dart';

class EditDrinkWidget extends StatefulWidget {
  final String drinkId;
  final String drinkName;
  final double drinkPrice;
  const EditDrinkWidget(
      {Key? key,
      required this.drinkId,
      required this.drinkName,
      required this.drinkPrice})
      : super(key: key);

  @override
  State<EditDrinkWidget> createState() => _EditDrinkWidgetState();
}

class _EditDrinkWidgetState extends State<EditDrinkWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String drinkName = "";
  double drinkPrice = 0;

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    Provider.of<Drinks>(context, listen: false)
        .editDrink(drinkName, drinkPrice, widget.drinkId)
        .then((_) {
      Navigator.of(context).pop();
    });
  }

  void _delete(){
        Provider.of<Drinks>(context, listen: false)
        .deleteDrink(widget.drinkId)
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
      title: const Text('Edit drink',
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
                  textInputAction: TextInputAction.next,
                  initialValue: widget.drinkName,
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
                  initialValue: widget.drinkPrice.toString(),
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
                    'Save changes',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const Divider(),
              SizedBox(
                height: 25,
                width: 120,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 148, 14, 5)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                  ),
                  onPressed: () => _delete(),
                  child: const Text(
                    'Delete drink',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          )
        ),
      ),
    );
  }
}
