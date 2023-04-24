import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authorization.dart';
import '../screens/sign_in_sign_up_screen.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  String _firstName = "";
  String _lastName = "";
  String _email = "";
  String _password = "";

  var _loading = false;

  final _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _showErrorMessage(String errorMessage) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('An Error Occured!'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Okay'))
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
          .signup(_firstName, _lastName, _email, _password);
    } on HttpException catch (error) {
      var _errorMessage = "Signing up failed";
      if (error.toString().contains('EMAIL_EXISTS')) {
        _errorMessage = "This email is already in use.";
      } else if (error.toString().contains('INVALID_EMAIL')) {
        _errorMessage = "This is not a valid email address.";
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        _errorMessage = "Your password is too weak";
      }
      _showErrorMessage(_errorMessage);
    } catch (error) {
      var _errorMessage = "Oops there is an error, please try again later";
      _showErrorMessage(_errorMessage);
    }

    setState(() {
      _loading = false;
    });
    Navigator.of(context).pushReplacementNamed('/');
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
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'First Name',
                hintStyle: TextStyle(color: Colors.white),
                icon: Icon(Icons.person, color: Colors.yellow),
              ),
              validator: (value) {
                if (value!.isEmpty) return "First Name is Required";
              },
              onSaved: (value) {
                _firstName = value!;
              },
            ),
          ),
          InputField(
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Last Name',
                hintStyle: TextStyle(color: Colors.white),
                icon: Icon(Icons.person, color: Colors.yellow),
              ),
              validator: (value) {
                if (value!.isEmpty) return "Last Name is Required";
              },
              onSaved: (value) {
                _lastName = value!;
              },
            ),
          ),
          InputField(
            child: TextFormField(
              textInputAction: TextInputAction.next,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Your Email',
                hintStyle: TextStyle(color: Colors.white),
                icon: Icon(Icons.email, color: Colors.yellow),
              ),
              validator: (value) {
                RegExp regExp =
                    RegExp(r'^[^\s@A-Z]{1,}[@][^\s@A-Z]{1,}[.][^\s@A-Z]{1,}$');
                if (!regExp.hasMatch(value!)) {
                  return "Invalid Email";
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
              controller: _passwordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Password is Required";
                } else if (value.length < 8) {
                  return "Password needs at least 8 characters";
                }
              },
              onSaved: (value) {
                _password = value!;
              },
            ),
          ),
          InputField(
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Confirm Password',
                hintStyle: TextStyle(color: Colors.white),
                icon: Icon(Icons.lock, color: Colors.yellow),
              ),
              validator: (value) {
                if (value != _passwordController.text) {
                  return "Password do not match";
                }
              },
            ),
          ),
          _loading
              ? CircularProgressIndicator()
              : SizedBox(
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
                      'Sign Up',
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

class InputField extends StatelessWidget {
  final Widget child;
  const InputField({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(210, 82, 77, 75).withOpacity(0.7),
            const Color.fromARGB(255, 0, 0, 0).withOpacity(1),
          ],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: child,
    );
  }
}
