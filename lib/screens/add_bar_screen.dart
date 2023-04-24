import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as pathdart;
import 'package:provider/provider.dart';

import '../widgets/universal_price_list_app_bar_widget.dart';
import '../widgets/input_field_widget.dart';

import '../providers/bars.dart';

class AddBarScreen extends StatefulWidget {
  final String ownerId;
  const AddBarScreen({Key? key, required this.ownerId}) : super(key: key);

  @override
  State<AddBarScreen> createState() => _AddBarScreenState();
}

class _AddBarScreenState extends State<AddBarScreen> {
  File? image;
  UploadTask? uploadTask;
  String barName = "";
  String barLocation = "";
  var _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future selectImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final tempImage = File(image.path);
      setState(() {
        this.image = tempImage;
      });
    } on PlatformException catch (error) {
      return error;
    }
  }

  Future addBar() async {
    setState(() {
      _isLoading = true;
    });
    if (!_formKey.currentState!.validate()) {
      return;
    } else if (image == null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('An Error Occured!'),
                content: const Text('You didn\'t select an image!'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text(
                        'Okay',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ))
                ],
              ));
    } else {
      _formKey.currentState!.save();
      final imageUrl = await uploadImage();
      Provider.of<Bars>(context, listen: false)
          .addBar(barName, barLocation, imageUrl, widget.ownerId)
          .then((_) {
        Navigator.of(context).pop();
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future uploadImage() async {
    if (image == null) return;

    final ref = FirebaseStorage.instance.ref().child(
        '/images/${pathdart.basename(image!.path) + DateTime.now().millisecondsSinceEpoch.toString()}');
    uploadTask = ref.putFile(image!);

    final snapshot = await uploadTask!;
    final imageUrl = await snapshot.ref.getDownloadURL();

    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const UniversalPriceListAppBarWidget(appBarTitle: 'Add Your Bar'),
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
          ListView(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Divider(),
                    const InputField(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Please fill out the data below',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    image == null
                        ? Container()
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              image!,
                              width: size.width * 0.6,
                              height: size.height * 0.2,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            ),
                          ),
                    const Divider(),
                    InputField(
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Name of Your Bar',
                          hintStyle: TextStyle(color: Colors.white),
                          icon: Icon(Icons.coffee, color: Colors.yellow),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Name can't be empty";
                          }
                        },
                        onSaved: (value) {
                          barName = value!;
                        },
                      ),
                    ),
                    InputField(
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Location of Your Bar',
                          hintStyle: TextStyle(color: Colors.white),
                          icon: Icon(Icons.location_city, color: Colors.yellow),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Location can't be empty";
                          }
                        },
                        onSaved: (value) {
                          barLocation = value!;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      height: 45,
                      width: size.width * 0.6,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.yellow),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                        ),
                        onPressed: () => selectImage(),
                        child: image == null
                            ? const Text(
                                'Click here to select an image for Your Bar',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              )
                            : const Text(
                                'Image selected! Click again to change an image.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _isLoading
                ? const CircularProgressIndicator()
                : Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 45,
                    width: size.width * 0.8,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.amber),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                      ),
                      onPressed: () {
                        addBar();
                      },
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
          )
        ],
      ),
    );
  }
}
