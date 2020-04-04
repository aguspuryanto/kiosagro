import 'package:flutter/material.dart';
import 'package:kios_agro/providers/product_provider.dart';
import 'package:kios_agro/providers/user_provider.dart';
import 'package:kios_agro/screens/login_screen.dart';
import 'package:kios_agro/screens/register_screen.dart';
import 'package:kios_agro/screens/screen_control.dart';
import 'package:splashscreen/splashscreen.dart';
import './providers/auth_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider.instance(),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.green),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(
          image: Image.asset('logo.png'),
          photoSize: 100.0,
          seconds: 0,
          navigateAfterSeconds: Consumer(
            builder: (context, AuthProvider auth, _) {
              print(auth.status);
              print('user model');
              print(auth.userModel);
              switch (auth.status) {
                case Status.Authenticating:
                case Status.Uninitialized:
                  return RegisterScreen();
                  break;
                case Status.Unauthenticated:
                  return LoginScreen();
                  break;
                case Status.Authenticated:
                  return ScreenControl();
                  break;
              }
            },
          ),
        ),
      ),
    );
  }
}
