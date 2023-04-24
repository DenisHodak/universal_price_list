import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../providers/authorization.dart';
import './input_field_widget.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  String _email = "";
  String _password = "";

  var _loading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _showErrorMessage(String errorMessage) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Oops, an error occured!'),
              content: Text(errorMessage),
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
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _loading = true;
    });

    try {
      await Provider.of<Authorization>(context, listen: false)
          .signin(_email, _password);
    } on HttpException catch (error) {
      var errorMessage = "Signing in failed";
      if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = "Could not find a user with that email.";
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = "Invalid password";
      } else if (error.toString().contains("EMAIL_NOT_FOUND"))
      {
        errorMessage = "Could not find a user with that email.";
      }
      _showErrorMessage(errorMessage);
    } catch (error) {
      var errorMessage = "Oops there is an error, please try again later";
      _showErrorMessage(errorMessage);
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          InputField(
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: 'Your Email',
                hintStyle: TextStyle(color: Colors.white),
                icon: Icon(Icons.person, color: Colors.yellow),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Email is Required";
                }
              },
              onSaved: (value) {
                _email = value!;
              },
            ),
          ),
          InputField(
            child: TextFormField(
              textInputAction: TextInputAction.next,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Your Password',
                hintStyle: TextStyle(color: Colors.white),
                icon: Icon(Icons.lock, color: Colors.yellow),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Password is Required";
                }
              },
              onSaved: (value) {
                _password = value!;
              },
            ),
          ),
          SizedBox(
            height: 45,
            width: size.width * 0.8,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.yellow),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
              ),
              onPressed: () => _submit(),
              child: const Text(
                'Sign In',
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
    );
  }
}


