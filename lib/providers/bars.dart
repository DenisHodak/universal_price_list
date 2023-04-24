import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'bar.dart';

class Bars with ChangeNotifier {
  List<Bar> _bars = [];
  List<Bar> _myBars = [];

  Future<void> addBar(String barName, String barLocation, String imageUrl,
      String ownerId) async {
    final url = Uri.parse(
        'https://universal-price-list-default-rtdb.europe-west1.firebasedatabase.app/bars.json');
    try {
      http
          .post(url,
              body: json.encode({
                'name': barName,
                'location': barLocation,
                'image': imageUrl,
                'ownerId': ownerId,
              }))
          .then((response) {
        final newBar = Bar(
            id: json.decode(response.body)['name'],
            name: barName,
            location: barLocation,
            image: imageUrl);
        _bars.add(newBar);
        _myBars.add(newBar);
        notifyListeners();
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> editBar(
      {required String barId,
      required String barName,
      required String barImage,
      required String barLocation}) async {
    final url = Uri.parse(
        'https://universal-price-list-default-rtdb.europe-west1.firebasedatabase.app/bars/$barId.json');
    try {
      final response = http.patch(url,
          body: json.encode({
            'image': barImage,
            'location': barLocation,
            'name': barName,
          }));
      var currentBar =
          _myBars.where((element) => element.id == barId).first;
      currentBar.image = barImage;
      currentBar.location = barLocation;
      currentBar.name = barName;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteBar(String barId) async {
    final url = Uri.parse(
        'https://universal-price-list-default-rtdb.europe-west1.firebasedatabase.app/bars/$barId.json');
    try {
      final response = http.delete(url);
      _myBars.removeWhere((element) => element.id == barId);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<Bar> get myBars {
    return [..._myBars];
  }

  List<Bar> get bars {
    return [..._bars];
  }

  Future<void> getAllBars() async {
    final url = Uri.parse(
        'https://universal-price-list-default-rtdb.europe-west1.firebasedatabase.app/bars.json');
    try {
      final response = await http.get(url);
      final responseBody = json.decode(response.body) as Map<String, dynamic>;
      final List<Bar> loadedBars = [];
      responseBody.forEach((barId, bar) {
        loadedBars.add(Bar(
          id: barId,
          name: bar['name'],
          location: bar['location'],
          image: bar['image'],
        ));
      });
      _bars = loadedBars;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getMyBars(String ownerId) async {
    final url = Uri.parse(
        'https://universal-price-list-default-rtdb.europe-west1.firebasedatabase.app/bars.json?orderBy="ownerId"&equalTo="$ownerId"');
    try {
      final response = await http.get(url);
      final responseBody = json.decode(response.body) as Map<String, dynamic>;
      final List<Bar> myloadedbars = [];
      responseBody.forEach((barId, bar) {
        myloadedbars.add(Bar(
          id: barId,
          name: bar['name'],
          location: bar['location'],
          image: bar['image'],
        ));
      });
      _myBars = myloadedbars;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
