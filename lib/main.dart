import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './providers/authorization.dart';
import './providers/users.dart';
import './providers/bars.dart';
import './providers/drinks.dart';

import './screens/sign_in_sign_up_screen.dart';
import './screens/bars_list_screen.dart';
import './screens/users_list.dart';
import './screens/my_bars_screen.dart';
import './screens/loading_screen.dart';
import './config/config.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Config.apikey,
            appId: Config.appId,
            messagingSenderId: Config.messagingSenderId,
            projectId: Config.projectId));

    //flutter run -d chrome --web-renderer html
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Authorization(),
          ),
          ChangeNotifierProvider.value(
            value: Users(),
          ),
          ChangeNotifierProvider.value(
            value: Bars(),
          ),
          ChangeNotifierProvider.value(
            value: Drinks(),
          ),
        ],
        child: Consumer<Authorization>(
          builder: (ctx, authorizationData, _) => MaterialApp(
            title: 'Universal Price List',
            theme: ThemeData(
              primarySwatch: Colors.yellow,
            ),
            home: authorizationData.isAuth
                ? BarsListScreen(
                    userRole: authorizationData.userRole,
                    userName: authorizationData.userName)
                : FutureBuilder(
                    future: authorizationData.tryAutoSignIn(),
                    builder: (ctx, authResult) =>
                        authResult.connectionState == ConnectionState.waiting
                            ? LoadingScreen()
                            : const AuthorizationScreen()),
            routes: {
              BarsListScreen.routeName: (ctx) => BarsListScreen(
                  userRole: authorizationData.userRole,
                  userName: authorizationData.userName),
              AllUsersScreen.routeName: (ctx) => AllUsersScreen(
                  userRole: authorizationData.userRole,
                  userName: authorizationData.userName),
              MyBarsScreen.routeName: (ctx) => MyBarsScreen(
                    ownerId: authorizationData.userId,
                    userRole: authorizationData.userRole,
                    userName: authorizationData.userName,
                  ),
            },
          ),
        ));
  }
}
