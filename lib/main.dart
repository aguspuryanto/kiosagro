import 'package:flutter/material.dart';
import 'package:kios_agro/providers/cart_provider.dart';
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
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.green),
        debugShowCheckedModeBanner: false,
        home: Splash(),
      ),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        image: Image.asset('logo.png'),
        photoSize: 100.0,
        seconds: 0,
        navigateAfterSeconds: AfterSplash());
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthProvider>(context);
    var user = Provider.of<UserProvider>(context);

    return Consumer(
      builder: (context, AuthProvider auth, _) {
        switch (auth.status) {
          case Status.Authenticating:
          case Status.Uninitialized:
            return RegisterScreen();
            break;
          case Status.Unauthenticated:
            return LoginScreen();
            break;
          case Status.Authenticated:
            user.getUserData(auth.user.uid);

            return ScreenControl();
            break;
        }
      },
    );
  }
}
