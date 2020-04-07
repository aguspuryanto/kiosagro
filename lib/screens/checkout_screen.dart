import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kios_agro/main.dart';
import 'package:kios_agro/providers/cart_provider.dart';
import 'package:kios_agro/widgets/merchant_product_list.dart';
import 'package:provider/provider.dart';

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
    var cost = cart.selectedCourier;

    print(cart.getTotalWeight(cart.selectedMerchant));

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
                    Text('Ke salah satu rekening berikut:'),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      leading: Image.network(
                        'https://www.bankmandiri.co.id/image/layout_set_logo?img_id=31567&t=1582304184496',
                        width: 50,
                      ),
                      title: Text(
                        'Mandiri',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '131-00-2620202',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'PT. KIOSAGRO INDONESIA SEJAHTERA',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: () {},
                      color: Colors.green,
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Text(
                        'Saya Sudah Membayar',
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
