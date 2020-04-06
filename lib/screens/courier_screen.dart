import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:kios_agro/screens/checkout_screen.dart';

class CourierScreen extends StatefulWidget {
  @override
  _CourierScreenState createState() => _CourierScreenState();
}

class _CourierScreenState extends State<CourierScreen> {
  var listCost = [];

  @override
  void initState() {
    super.initState();
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
          'origin': '501',
          'originType': 'city',
          'destination': '574',
          'destinationType': 'subdistrict',
          'weight': '1700',
          'courier': 'jne'
        }).then((value) {
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
          'origin': '501',
          'originType': 'city',
          'destination': '574',
          'destinationType': 'subdistrict',
          'weight': '1700',
          'courier': 'jnt'
        }).then((value) {
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
    print(listCost);

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
            (listCost.length == 0
                ? Center(child: CircularProgressIndicator())
                : ListCost(listCost)),
          ],
        )),
      ),
    );
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
