import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:kios_agro/models/user_model.dart';
import 'package:kios_agro/providers/cart_provider.dart';
import 'package:kios_agro/providers/user_provider.dart';
import 'package:kios_agro/screens/checkout_screen.dart';
import 'package:provider/provider.dart';

class CourierScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context);
    var user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Pengiriman'),
      ),
      floatingActionButton: MaterialButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CheckOutScreen()));
        },
        color: Colors.green,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Pembayaran',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: FirebaseDatabase.instance
                  .reference()
                  .child('users/${cart.selectedMerchant}')
                  .once()
                  .then((value) {
                print(value.value);
                var seller =
                    UserModel.fromSnapshot(cart.selectedMerchant, value.value);
                cart.setSeller(seller);
                return seller;
              }).catchError((e) {
                print(e);
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  print('done');
                  return CourierList(cart, user.user);
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        )),
      ),
    );
  }
}

class CourierList extends StatefulWidget {
  var cart;
  UserModel user;

  CourierList(this.cart, this.user);

  @override
  _CourierListState createState() => _CourierListState();
}

class _CourierListState extends State<CourierList> {
  var listCost = [];
  UserModel seller;
  UserModel buyer;

  @override
  void initState() {
    super.initState();

    widget.cart.getTotalWeight(widget.cart.selectedMerchant);

    setState(() {
      seller = widget.cart.seller;
      buyer = widget.user;
    });

    getCost();
  }

  getCost() async {
    var listJneCost = await getJneCost();
    var listJntCost = await getJntCost();
    setState(() {
      listCost = [...listJneCost, ...listJntCost];
    });
  }

  getJneCost() async {
    var tempList = [];

    await Dio().post('https://pro.rajaongkir.com/api/cost',
        options: Options(
          headers: {
            'key': 'eb9420bd896a4915739f4d8bc1e6ba13',
          },
        ),
        data: {
          'origin':
              '${seller.alamat['id'].replaceAll(new RegExp(r'[^\w\s]+'), '')}',
          'originType': 'subdistrict',
          'destination':
              '${buyer.alamat['id'].replaceAll(new RegExp(r'[^\w\s]+'), '')}',
          'destinationType': 'subdistrict',
          'weight': '${widget.cart.getTotalWeight(seller.key)}',
          'courier': 'jne'
        }).then((value) {
      // print(value.data);
      var data = value.data['rajaongkir']['results'][0]['costs'];
      var code = value.data['rajaongkir']['results'][0]['code'];
      data.forEach((cost) {
        cost['code'] = code;
        tempList.add(cost);
      });
    }).catchError((e) {
      print(e);
    });

    return tempList;
  }

  getJntCost() async {
    var tempList = [];

    await Dio().post('https://pro.rajaongkir.com/api/cost',
        options: Options(
          headers: {
            'key': 'eb9420bd896a4915739f4d8bc1e6ba13',
          },
        ),
        data: {
          'origin':
              '${seller.alamat['id'].replaceAll(new RegExp(r'[^\w\s]+'), '')}',
          'originType': 'subdistrict',
          'destination':
              '${buyer.alamat['id'].replaceAll(new RegExp(r'[^\w\s]+'), '')}',
          'destinationType': 'subdistrict',
          'weight': '${widget.cart.getTotalWeight(seller.key)}',
          'courier': 'jnt'
        }).then((value) {
      // print(value.data);
      var data = value.data['rajaongkir']['results'][0]['costs'];
      var code = value.data['rajaongkir']['results'][0]['code'];
      data.forEach((cost) {
        cost['code'] = code;
        tempList.add(cost);
      });
    }).catchError((e) {
      print(e);
    });

    return tempList;
  }

  @override
  Widget build(BuildContext context) {
    return (listCost.length == 0
        ? Center(child: CircularProgressIndicator())
        : ListCost(listCost));
  }
}

class ListCost extends StatefulWidget {
  var listCost;

  ListCost(this.listCost);

  @override
  _ListCostState createState() => _ListCostState();
}

class _ListCostState extends State<ListCost> {
  var selectedCost;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedCost = widget.listCost[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context);
    cart.setCourier(selectedCost);

    return Column(
      children: widget.listCost.map<Widget>((cost) {
        return ListTile(
          leading: Container(
            height: 50,
            width: 75,
            child: Builder(
              builder: (context) {
                switch (cost['code'].toLowerCase()) {
                  case 'jne':
                    return Image.asset('jne.jpg', fit: BoxFit.fill);
                    break;
                  case 'j&t':
                    return Image.asset(
                      'jnt.jpg',
                      fit: BoxFit.fill,
                    );
                  default:
                    return Icon(Icons.image);
                }
              },
            ),
          ),
          trailing: Radio(
            value: cost,
            groupValue: selectedCost,
            onChanged: (newValue) {
              setState(() {
                selectedCost = newValue;
                cart.setCourier(newValue);
              });
            },
          ),
          isThreeLine: true,
          title: Text('${cost['code'].toUpperCase()} - ${cost['service']}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Biaya Pengiriman: ${cost['cost'][0]['value']}',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              Text(
                'Durasi: ${(cost['cost'][0]['etd'].isEmpty ? '-' : cost['cost'][0]['etd'])} hari',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
