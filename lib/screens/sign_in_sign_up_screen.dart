import 'package:flutter/material.dart';

import '../widgets/sign_in_widget.dart';
import '../widgets/sign_up_widget.dart';

enum AuthenticationMode { signin, signup }

class AuthorizationScreen extends StatelessWidget {
  const AuthorizationScreen({Key? key}) : super(key: key);

  static const routeName = '/authorization';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
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
            children: const <Widget>[
              Image(
                height: 300,
                color: Colors.yellow,
                image:
                    AssetImage('assets/images/universal_price_list-logo.png'),
                alignment: Alignment.topCenter,
              ),
              AuthorizationWidget(),
            ],
          )
        ],
      ),
    );
  }
}

class AuthorizationWidget extends StatefulWidget {
  const AuthorizationWidget({Key? key}) : super(key: key);

  @override
  State<AuthorizationWidget> createState() => _AuthorizationWidgetState();
}

class _AuthorizationWidgetState extends State<AuthorizationWidget> {
  AuthenticationMode _authenticationMode = AuthenticationMode.signin;

  void _changeAuthorizationMode() {
    if (_authenticationMode == AuthenticationMode.signin) {
      setState(() {
        _authenticationMode = AuthenticationMode.signup;
      });
    } else {
      setState(() {
        _authenticationMode = AuthenticationMode.signin;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _authenticationMode == AuthenticationMode.signin
            ? SignInWidget()
            : SignUpWidget(),
        TextButton(
          onPressed: _changeAuthorizationMode,
          child: _authenticationMode == AuthenticationMode.signin
              ? const Text('Sign Up Instead')
              : const Text('Sign In Instead'),
        )
      ],
    );
  }
}
