import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kios_agro/providers/user_provider.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../services/alamat_service.dart';

class AccountAppBar extends StatelessWidget implements PreferredSizeWidget {
  final _height;

  AccountAppBar(this._height);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(_height),
      child: AppBar(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_height);
}

class AccountScreen extends StatefulWidget {
  final _key;

  AccountScreen(this._key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool jne;
  bool upgrade = false;

  var listProvinsi = [];
  var listKabupaten = [];
  var listKecamatan = [];

  var _provinsi;
  var _kabupaten;
  var _kecamatan;

  @override
  void initState() {
    super.initState();

    getProvinsi();
  }

  getProvinsi() {
    setState(() {
      listProvinsi = provinsi;
    });
  }

  getKabupaten(provinceId) {
    var kabList = kabupaten;
    var tempList = [];
    kabList.forEach((prov) {
      if (prov['province_id'] == provinceId) {
        tempList.add(prov);
      }
    });
    setState(() {
      listKabupaten = tempList;
    });
    print(listKabupaten);
  }

  getKecamatan(cityId) {
    Dio()
        .get('https://pro.rajaongkir.com/api/subdistrict?city=$cityId',
            options: Options(headers: {
              "key": "eb9420bd896a4915739f4d8bc1e6ba13",
            }))
        .then(
      (value) {
        var tempList = [];
        value.data['rajaongkir']['results'].forEach((prov) {
          if (prov['city_id'] == cityId) {
            tempList.add(prov);
          }
        });
        setState(() {
          listKecamatan = tempList;
        });
        print(listKecamatan);
      },
    );
  }

  getInit(user) {
    if (!user.user.alamat['provinsi'].isEmpty) {
      setState(() {
        _provinsi = user.user.alamat['provinsi'];
      });
    }

    if (!user.user.alamat['kabupaten'].isEmpty) {
      setState(() {
        _kabupaten = user.user.alamat['kabupaten'];
      });
    }

    if (!user.user.alamat['kecamatan'].isEmpty) {
      setState(() {
        _kecamatan = user.user.alamat['kecamatan'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = Provider.of<UserProvider>(context);

    getInit(user);

    return SafeArea(
      child: SingleChildScrollView(
        child: (user.user == null
            ? CircularProgressIndicator()
            : Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Akun Pembeli',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      enabled: false,
                      initialValue: user.user.email,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email: ',
                        labelStyle: TextStyle(
                          color: Colors.green,
                        ),
                        disabledBorder: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      initialValue: user.user.nama,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nama Lengkap: ',
                        labelStyle: TextStyle(
                          color: Colors.green,
                        ),
                        disabledBorder: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      initialValue: user.user.telepon,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nomor Telepon: ',
                        labelStyle: TextStyle(
                          color: Colors.green,
                        ),
                        disabledBorder: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      initialValue: user.user.alamat['alamat'],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Alamat: ',
                        labelStyle: TextStyle(
                          color: Colors.green,
                        ),
                        disabledBorder: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          elevation: 2,
                          isExpanded: true,
                          hint: Text('Provinsi'),
                          onChanged: (newValue) {
                            setState(() {
                              _provinsi = newValue;
                              _kabupaten = null;
                              _kecamatan = null;
                              print(newValue);
                            });
                            getKabupaten(newValue);
                          },
                          value: _provinsi,
                          items: listProvinsi.map<DropdownMenuItem<dynamic>>(
                            (item) {
                              return DropdownMenuItem(
                                child: Text(item['province']),
                                value: item['province_id'],
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          elevation: 2,
                          isExpanded: true,
                          hint: Text('Kabupaten'),
                          disabledHint: Text('Kabupaten'),
                          onChanged: (newValue) {
                            setState(() {
                              _kabupaten = newValue;
                              _kecamatan = null;
                              print(newValue);
                            });
                            getKecamatan(newValue);
                          },
                          value: _kabupaten,
                          items: listKabupaten.length == 0
                              ? null
                              : listKabupaten.map<DropdownMenuItem<dynamic>>(
                                  (item) {
                                    return DropdownMenuItem(
                                      child: Text(item['city_name']),
                                      value: item['city_id'],
                                    );
                                  },
                                ).toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          elevation: 2,
                          isExpanded: true,
                          hint: Text('Kecamatan'),
                          disabledHint: Text('Kecamatan'),
                          onChanged: (newValue) {
                            setState(() {
                              _kecamatan = newValue;
                              print(newValue);
                            });
                          },
                          value: _kecamatan,
                          items: listKecamatan.length == 0
                              ? null
                              : listKecamatan.map<DropdownMenuItem<dynamic>>(
                                  (item) {
                                    return DropdownMenuItem(
                                      child: Text(item['subdistrict_name']),
                                      value: item['subdistrict_id'],
                                    );
                                  },
                                ).toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    (user.user.verifyshop == null && upgrade == false
                        ? MaterialButton(
                            minWidth: MediaQuery.of(context).size.width - 40,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.green),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 20),
                            onPressed: () {
                              setState(() {
                                upgrade = true;
                              });
                            },
                            child: Text(
                              'Upgrade Penjual',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          )
                        : SellerAccount(
                            widget._key,
                            user,
                          )),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: () {
                        auth.signOut();
                      },
                      minWidth: MediaQuery.of(context).size.width - 40,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 50,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.red,
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    )
                  ],
                ),
              )),
      ),
    );
  }
}

class SellerAccount extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key;
  final user;

  SellerAccount(this._key, this.user);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Akun Penjual',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          enabled: (user.user.verifyshop == null ? true : false),
          initialValue: user.user.namatoko,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nama Toko: ',
            labelStyle: TextStyle(
              color: Colors.green,
            ),
            disabledBorder: OutlineInputBorder(),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          enabled: (user.user.verifyshop == null ? true : false),
          initialValue: user.user.urltoko,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'URL Toko: ',
            labelStyle: TextStyle(
              color: Colors.green,
            ),
            disabledBorder: OutlineInputBorder(),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        MaterialButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: 'Rifqi Ganteng'));
            _key.currentState
                .showSnackBar(SnackBar(content: Text('Link Berhasil Disalin')));
          },
          minWidth: MediaQuery.of(context).size.width,
          color: Colors.green,
          padding: EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Copy Link',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          enabled: false,
          initialValue: user.user.rekening,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nomor Rekening: ',
            labelStyle: TextStyle(
              color: Colors.green,
            ),
            disabledBorder: OutlineInputBorder(),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          enabled: false,
          initialValue: user.user.bank,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nama Bank: ',
            labelStyle: TextStyle(
              color: Colors.green,
            ),
            disabledBorder: OutlineInputBorder(),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          enabled: false,
          initialValue: user.user.holder,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nama Pemilik Rekening: ',
            labelStyle: TextStyle(
              color: Colors.green,
            ),
            disabledBorder: OutlineInputBorder(),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        MaterialButton(
          onPressed: () {},
          minWidth: MediaQuery.of(context).size.width,
          color: Colors.green,
          padding: EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Generate Toko',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Pilihan Pengiriman',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        (user.user.verifyshop == null
            ? Container()
            : CheckboxListTile(
                value: true,
                onChanged: (val) {},
                title: Row(
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 100,
                      child: Image.network(
                          'https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2F4.bp.blogspot.com%2F-aSIrvq-O52s%2FUTUKkn-NY0I%2FAAAAAAAAACY%2F7ekOHtjLWw8%2Fs1600%2FLogo%2BJNE.JPG&f=1&nofb=1',
                          fit: BoxFit.fill),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'JNE',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              )),
        SizedBox(
          height: 20,
        ),
        CheckboxListTile(
          value: true,
          onChanged: (val) {},
          title: Row(
            children: <Widget>[
              Container(
                height: 50,
                width: 100,
                child: Image.network(
                  'https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2F2.bp.blogspot.com%2F-4_rZJk1uI6k%2FUTUH2D_NaCI%2FAAAAAAAAAB4%2FbQ9befjlAxo%2Fs1600%2FLogo%2BTiki.JPG&f=1&nofb=1',
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                'Tiki',
                style: TextStyle(
                  fontSize: 20,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        MaterialButton(
          onPressed: () {},
          minWidth: MediaQuery.of(context).size.width,
          color: Colors.green,
          padding: EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Simpan Perubahan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
