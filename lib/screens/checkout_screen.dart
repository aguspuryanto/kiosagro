import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kios_agro/main.dart';
import 'package:kios_agro/providers/cart_provider.dart';
import 'package:kios_agro/providers/user_provider.dart';
import 'package:kios_agro/widgets/merchant_product_list.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckOutScreen extends StatefulWidget {
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context);
    var user = Provider.of<UserProvider>(context);
    var cost = cart.selectedCourier;

    launchUrl(url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'tidak bisa launch $url';
      }
    }

    handleSubmit() {
      var url = 'https://app.sandbox.midtrans.com/snap/v1/transactions';
      var username = 'SB-Mid-server-uHFIshW8HZ_EsEeylY7mUQYb';
      var password = '';
      var basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      var data = {
        'transaction_details': {
          "order_id": DateTime.now().toString(),
          "gross_amount": cart.grossAmount
        },
        'credit_card': {'secure': true},
        'customer_details': {
          'first_name': user.user.nama,
          'last_name': user.user.nama,
          'email': user.user.email,
          'phone': user.user.telepon,
        },
        'billing_address': {
          'first_name': user.user.nama,
          'last_name': user.user.nama,
          'email': user.user.email,
          'phone': user.user.telepon,
          'address': user.user.alamat['alamat'],
          'city': user.user.alamat['kabupaten'],
          'country_code': 'IDN'
        },
        'shipping_address': {
          'first_name': user.user.nama,
          'last_name': user.user.nama,
          'email': user.user.email,
          'phone': user.user.telepon,
          'address': user.user.alamat['alamat'],
          'city': user.user.alamat['kabupaten'],
          'country_code': 'IDN'
        }
      };

      print(basicAuth);
      print(data);
      Dio()
          .post(url,
              options: Options(headers: {
                'Authorization': basicAuth,
                'Content-Type': 'application/json',
                'Accept': 'application/json'
              }),
              data: data)
          .then((value) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        launchUrl(value.data['redirect_url']);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AfterSplash()));
            }),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.green,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Nama Toko: ${cart.seller.namatoko}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),
                      MerchantProductList(cart.selectedMerchant, false),
                      ListTile(
                        leading: Container(
                          height: 50,
                          width: 75,
                          child: Builder(
                            builder: (context) {
                              switch (cost['code'].toLowerCase()) {
                                case 'jne':
                                  return Image.asset('jne.jpg',
                                      fit: BoxFit.fill);
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
                        isThreeLine: true,
                        title: Text(
                            '${cost['code'].toUpperCase()} - ${cost['service']}'),
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
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: <Widget>[
                    Text('Harap melakukan pembayaran sejumlah'),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Rp ${cart.grossAmount}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      onPressed: () {
                        handleSubmit();
                      },
                      color: Colors.green,
                      minWidth: MediaQuery.of(context).size.width - 100,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Text(
                        'Pilih Pembayaran',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
