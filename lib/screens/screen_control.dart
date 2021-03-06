import 'package:flutter/material.dart';
import 'package:kios_agro/providers/auth_provider.dart';
import 'package:kios_agro/providers/user_provider.dart';
import 'package:kios_agro/screens/order_screen.dart';
import 'package:kios_agro/screens/store_screen.dart';
import 'package:provider/provider.dart';
import 'account_screen.dart';
import 'home_screen.dart';

class ScreenControl extends StatefulWidget {
  @override
  _ScreenControlState createState() => _ScreenControlState();
}

class _ScreenControlState extends State<ScreenControl> {
  int _selectedIndex = 0;
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = Provider.of<UserProvider>(context);

    // user.getUserData(auth.user.uid);

    var appBarList = [
      HomeAppBar(80.0),
      StoreAppBar(50.0),
      OrderAppBar(50.0),
      AccountAppBar(0.0)
    ];
    var ScreenList = [
      HomeScreen(),
      StoreScreen(),
      OrderScreen(),
      AccountScreen(_key, user),
    ];

    return Scaffold(
      key: _key,
      appBar: appBarList[_selectedIndex],
      body: ScreenList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) {
          if (user.user != null) {
            setState(() {
              _selectedIndex = idx;
            });
          } else {
            auth.setStatus(Status.Unauthenticated);
          }
        },
        currentIndex: _selectedIndex,
        showUnselectedLabels: false,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Beranda'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            title: Text('Toko Anda'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            title: Text('Pesanan'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Akun'),
          ),
        ],
      ),
    );
  }
}
