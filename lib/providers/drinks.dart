import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './drink.dart';

class Drinks extends ChangeNotifier {
  List<Drink> _drinks = [];

  List<Drink> get drinks {
    return [..._drinks];
  }

  Future<void> addDrink(String name, double price, String barId) async {
    final url = Uri.parse(
        'https://universal-price-list-default-rtdb.europe-west1.firebasedatabase.app/drinks.json');
    try {
      http
          .post(url,
              body: json.encode({
                'name': name,
                'price': price,
                'barId': barId,
              }))
          .then((response) {
        final newDrink = Drink(
          id: json.decode(response.body)['name'],
          title: name,
          price: price,
          barId: barId,
        );
        _drinks.add(newDrink);
        notifyListeners();
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getAllDrinks(String barId) async {
    final url = Uri.parse(
        'https://universal-price-list-default-rtdb.europe-west1.firebasedatabase.app/drinks.json?orderBy="barId"&equalTo="$barId"');
    try {
      final response = await http.get(url);
      final responseBody = json.decode(response.body) as Map<String, dynamic>;
      final List<Drink> loadedDrinks = [];
      responseBody.forEach((drinkId, drink) {
        loadedDrinks.add(Drink(
          id: drinkId,
          title: drink['name'],
          price: double.parse(drink['price'].toStringAsFixed(2)),
          barId: drink['barId'],
        ));
      });
      _drinks = loadedDrinks;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> editDrink(
      String drinkName, double drinkPrice, String drinkId) async {
    final url = Uri.parse(
        'https://universal-price-list-default-rtdb.europe-west1.firebasedatabase.app/drinks/$drinkId.json');
    try {
      final response = http.patch(url,
          body: json.encode({
            'name': drinkName,
            'price': drinkPrice,
          }));
      var currentDrink =
          _drinks.where((element) => element.id == drinkId).first;
      currentDrink.price = drinkPrice;
      currentDrink.title = drinkName;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteDrink(String drinkId) async {
    final url = Uri.parse(
        'https://universal-price-list-default-rtdb.europe-west1.firebasedatabase.app/drinks/$drinkId.json');
    try {
      final response = http.delete(url);
      _drinks.removeWhere((element) => element.id == drinkId);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
