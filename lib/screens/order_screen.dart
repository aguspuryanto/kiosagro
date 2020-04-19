import 'package:flutter/material.dart';
import 'package:kios_agro/providers/user_provider.dart';
import 'package:provider/provider.dart';

enum UserStatus { Pembeli, Penjual }

class OrderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final _height;

  OrderAppBar(this._height);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(_height),
      child: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Pesanan Anda'),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_height);
}

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var status;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    status = UserStatus.Pembeli;
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context);

    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      status = UserStatus.Pembeli;
                    });
                  },
                  minWidth: MediaQuery.of(context).size.width / 2,
                  color: (status == UserStatus.Pembeli
                      ? Colors.green
                      : Colors.white),
                  child: Text(
                    'Pembeli',
                    style: TextStyle(
                      color: (status == UserStatus.Penjual
                          ? Colors.green
                          : Colors.white),
                      fontSize: 20,
                    ),
                  ),
                ),
                MaterialButton(
                  minWidth: MediaQuery.of(context).size.width / 2,
                  onPressed: () {
                    setState(() {
                      status = UserStatus.Penjual;
                    });
                  },
                  color: (status == UserStatus.Penjual
                      ? Colors.green
                      : Colors.white),
                  child: Text(
                    'Penjual',
                    style: TextStyle(
                      color: (status == UserStatus.Pembeli
                          ? Colors.green
                          : Colors.white),
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            (status == UserStatus.Pembeli
                ? PembeliContent(user)
                : PenjualContent(user)),
          ],
        ),
      ),
    );
  }
}

class PembeliContent extends StatefulWidget {
  UserProvider user;
  PembeliContent(this.user);

  @override
  _PembeliContentState createState() => _PembeliContentState();
}

class _PembeliContentState extends State<PembeliContent> {
  List orderList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var tempList = [];

    try {
      widget.user.user.orders['buyer'].forEach((key, order) {
        tempList.add(order);
      });

      orderList = tempList;
    } catch (e) {}
    ;
  }

  @override
  Widget build(BuildContext context) {
    return (orderList.length == 0
        ? Center(
            child: Text('Tidak ada pesanan'),
          )
        : Column(
            children: orderList.map<Widget>((order) {
              return OrderWidget(order);
            }).toList(),
          ));
  }
}

class PenjualContent extends StatefulWidget {
  UserProvider user;
  PenjualContent(this.user);

  @override
  _PenjualContentState createState() => _PenjualContentState();
}

class _PenjualContentState extends State<PenjualContent> {
  List orderList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var tempList = [];

    try {
      widget.user.user.orders['seller'].forEach((key, order) {
        tempList.add(order);
      });

      orderList = tempList;
    } catch (e) {}
    ;
  }

  @override
  Widget build(BuildContext context) {
    return (orderList.length == 0
        ? Center(
            child: Text('Tidak ada pesanan'),
          )
        : Column(
            children: orderList.map<Widget>((order) {
              return OrderWidgetPenjual(order);
            }).toList(),
          ));
  }
}

class OrderWidget extends StatelessWidget {
  var order;
  OrderWidget(this.order);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text('Toko: ${order['seller_name']}'),
          ),
          Column(
            children: order['item_details'].map<Widget>((item) {
              return ListTile(
                title: Text(item['title']),
                subtitle: Text('${item['quantity'].toString()}x'),
                trailing: Text('Rp ${item['price']}'),
              );
            }).toList(),
          ),
          ListTile(
            title: Text('Total: Rp ${order['gross_amount']}'),
            subtitle: Text('Kode unik: ${order['unique']}'),
          ),
          Divider(),
          ListTile(
            title: Text('Status'),
            subtitle: Text('Belum dikirim'),
          )
        ],
      ),
    );
  }
}

class OrderWidgetPenjual extends StatelessWidget {
  var order;
  OrderWidgetPenjual(this.order);

  @override
  Widget build(BuildContext context) {
    Future<void> inputResiDialog() async {
      print(order);
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Masukkan Nomor Resi'),
            content: TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: 'Nomor Resi',
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Regret'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text('Toko: ${order['seller_name']}'),
          ),
          Column(
            children: order['item_details'].map<Widget>((item) {
              return ListTile(
                title: Text(item['title']),
                subtitle: Text('${item['quantity'].toString()}x'),
                trailing: Text('Rp ${item['price']}'),
              );
            }).toList(),
          ),
          ListTile(
            title: Text('Total: Rp ${order['gross_amount']}'),
            subtitle: Text('Kode unik: ${order['unique']}'),
          ),
          Divider(),
          ListTile(
            title: Text('Status'),
            subtitle: Text(order['status']),
            trailing: MaterialButton(
              onPressed: () {
                inputResiDialog();
              },
              color: Colors.green,
              child: Text(
                'Input Resi',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProductDetail extends StatelessWidget {
  var product;

  ProductDetail(this.product);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
