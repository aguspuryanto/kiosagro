import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
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
  UserProvider _user;

  AccountScreen(this._key, this._user);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  TextEditingController _nama = TextEditingController(text: '');
  TextEditingController _noTelp = TextEditingController(text: '');
  TextEditingController _namaToko = TextEditingController(text: '');
  TextEditingController _alamat = TextEditingController(text: '');
  TextEditingController _noRek = TextEditingController(text: '');
  TextEditingController _namaBank = TextEditingController(text: '');
  TextEditingController _namaHolder = TextEditingController(text: '');

  var _provinsi;
  var _kabupaten;
  var _kecamatan;

  //data akun penjual
  var _urlToko = 'dibuat otomatis setelah generate';

  bool jne = false;
  bool jnt = false;
  bool lion = false;
  bool pos = false;
  bool sicepat = false;
  bool tiki = false;
  bool upgrade = false;

  var listProvinsi = [];
  var listKabupaten = [];
  var listKecamatan = [];

  @override
  void initState() {
    super.initState();

    getProvinsi();

    getInit(widget._user);
  }

  checkIsEmptyOrNull(atribute) {
    if (atribute == null || atribute.isEmpty)
      return true;
    else
      return false;
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
      },
    );
  }

  getInit(user) {
    setState(() {
      if (!checkIsEmptyOrNull(widget._user.user.nama)) {
        _nama.text = widget._user.user.nama;
      }

      if (!checkIsEmptyOrNull(widget._user.user.telepon)) {
        _noTelp.text = widget._user.user.telepon;
      }

      if (!checkIsEmptyOrNull(widget._user.user.alamat['alamat'])) {
        _alamat.text = widget._user.user.alamat['alamat'];
      }

      if (!checkIsEmptyOrNull(widget._user.user.namatoko)) {
        _namaToko.text = widget._user.user.namatoko;
      }

      if (!checkIsEmptyOrNull(widget._user.user.rekening)) {
        _noRek.text = widget._user.user.rekening;
      }

      if (!checkIsEmptyOrNull(widget._user.user.bank)) {
        _namaBank.text = widget._user.user.bank;
      }

      if (!checkIsEmptyOrNull(widget._user.user.holder)) {
        _namaHolder.text = widget._user.user.holder;
      }

      if (user.user.pengiriman.toLowerCase().contains('jne')) {
        jne = true;
      }

      if (user.user.pengiriman.toLowerCase().contains('jnt')) {
        jnt = true;
      }

      if (user.user.pengiriman.toLowerCase().contains('lion')) {
        lion = true;
      }

      if (user.user.pengiriman.toLowerCase().contains('pos')) {
        pos = true;
      }

      if (user.user.pengiriman.toLowerCase().contains('sicepat')) {
        sicepat = true;
      }

      if (user.user.pengiriman.toLowerCase().contains('tiki')) {
        tiki = true;
      }
    });

    if (!checkIsEmptyOrNull(user.user.alamat['provinsi'])) {
      setState(() {
        _provinsi = user.user.alamat['id_provinsi'];
      });
    }

    if (!checkIsEmptyOrNull(user.user.alamat['kabupaten'])) {
      getKabupaten(user.user.alamat['id_provinsi']);
      setState(() {
        _kabupaten = user.user.alamat['id_kabupaten'];
      });
    }

    if (!checkIsEmptyOrNull(user.user.alamat['kecamatan'])) {
      getKecamatan(user.user.alamat['id_kabupaten']);
      setState(() {
        _kecamatan = user.user.alamat['id'];
      });
    }

    if (user.user.pengiriman.toLowerCase().contains('jne')) {
      setState(() {
        jne = true;
      });
    }

    if (user.user.pengiriman.toLowerCase().contains('tiki')) {
      setState(() {
        tiki = true;
      });
    }

    if (!checkIsEmptyOrNull(user.user.urltoko.toLowerCase())) {
      setState(() {
        _urlToko = user.user.urltoko;
      });
    }
  }

  handleGenerate() {
    var namaToko = _namaToko.text.replaceAll(new RegExp(r"\s+\b|\b\s"), "");

    var isReady;

    FirebaseDatabase().reference().child('home/urltoko').once().then((value) {
      var listUrl = value.value;
      print(listUrl);
      if (listUrl.contains(namaToko)) {
        isReady = true;
      } else {
        isReady = false;
        var toko = {
          'namatoko': _namaToko.text,
          'urltoko': 'https://www.kiosagro.com/kios/$namaToko',
          'verifyshop': true
        };

        FirebaseDatabase.instance
            .reference()
            .child('/users/${widget._user.user.key.toString()}')
            .update(toko)
            .then((value) {
          widget._user.getUserData(widget._user.user.key);
          setState(() {
            _urlToko = 'https://www.kiosagro.com/kios/$namaToko';
          });
          return true;
        }).catchError((e) {
          print(e);
        });
      }
    });

    if (isReady == true)
      return false;
    else
      return true;
  }

  handleSubmit() async {
    var kurir = '';
    if (jne == true) kurir = 'jne:$kurir';
    if (jnt == true) kurir = 'jnt:$kurir';
    if (pos == true) kurir = 'pos:$kurir';
    if (sicepat == true) kurir = 'sicepat:$kurir';
    if (lion == true) kurir = 'lion:$kurir';
    if (tiki == true) kurir = 'tiki:$kurir';

    var _provinsiName = '';
    var _kabupatenName = '';
    var _kecamatanName = '';

    listProvinsi.forEach((prov) {
      if (prov['province_id'] == _provinsi) _provinsiName = prov['province'];
    });
    listKabupaten.forEach((kab) {
      if (kab['city_id'] == _kabupaten) _kabupatenName = kab['city_name'];
    });
    listKecamatan.forEach((kec) {
      if (kec['subdistrict_id'] == _kecamatan)
        _kecamatanName = kec['subdistrict_name'];
    });

    var accountData = {
      'nama': _nama.text,
      'telepon': _noTelp.text,
      'alamat': {
        'id': _kecamatan,
        'id_kabupaten': _kabupaten,
        'id_provinsi': _provinsi,
        'alamat': _alamat.text,
        'kecamatan': _kecamatanName,
        'kabupaten': _kabupatenName,
        'provinsi': _provinsiName
      },
      'rekening': _noRek.text,
      'bank': _namaBank.text,
      'holder': _namaHolder.text,
      'pengiriman': kurir
    };

    widget._user.updateData(accountData);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = Provider.of<UserProvider>(context);

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
                      controller: _nama,
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
                      controller: _noTelp,
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
                      controller: _alamat,
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
                    (user.user.verifyshop == false && upgrade == false
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
                        : Column(
                            children: <Widget>[
                              Text(
                                'Akun Penjual',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(
                                '*akun penjual hanya bisa dibuat sekali',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                enabled: (user.user.verifyshop == false
                                    ? true
                                    : false),
                                controller: _namaToko,
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
                                enabled: false,
                                initialValue: _urlToko,
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
                              (user.user.verifyshop == false
                                  ? MaterialButton(
                                      onPressed: () {
                                        if (_namaToko.text.isEmpty) {
                                          widget._key.currentState.showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                  'Nama toko tidak boleh kosong'),
                                            ),
                                          );
                                        } else {
                                          if (handleGenerate() == false) {
                                            widget._key.currentState
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor: Colors.red,
                                                content:
                                                    Text('nama toko sudah ada'),
                                              ),
                                            );
                                          } else {
                                            user.getUserData(user.user.key);
                                            widget._key.currentState
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor: Colors.green,
                                                content: Text(
                                                    'toko berhasil dibuat'),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      color: Colors.green,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
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
                                    )
                                  : MaterialButton(
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(
                                            text: 'Rifqi Ganteng'));
                                        widget._key.currentState.showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Link Berhasil Disalin ${user.user.urltoko}')));
                                      },
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      color: Colors.green,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
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
                                    )),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Informasi Rekening',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: _noRek,
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
                                controller: _namaBank,
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
                                controller: _namaHolder,
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
                              CheckboxListTile(
                                value: jne,
                                onChanged: (val) {
                                  setState(() {
                                    jne = val;
                                  });
                                },
                                title: Row(
                                  children: <Widget>[
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/projectflutter-9b7b1.appspot.com/o/cms%2Fjne.png?alt=media&token=08b22e03-5022-4f41-9b81-03e2c887c503',
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
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CheckboxListTile(
                                value: jnt,
                                onChanged: (val) {
                                  setState(() {
                                    jnt = val;
                                  });
                                },
                                title: Row(
                                  children: <Widget>[
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/projectflutter-9b7b1.appspot.com/o/cms%2Fjnt.jpeg?alt=media&token=1de13921-1da4-4eb0-a4c9-502637f638e0',
                                          fit: BoxFit.fill),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'JNT',
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
                              CheckboxListTile(
                                value: lion,
                                onChanged: (val) {
                                  setState(() {
                                    lion = val;
                                  });
                                },
                                title: Row(
                                  children: <Widget>[
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/projectflutter-9b7b1.appspot.com/o/cms%2Flion.jpeg?alt=media&token=ba29ebcd-70ce-4c96-8865-539213a1e0be',
                                          fit: BoxFit.fill),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'LION',
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
                              CheckboxListTile(
                                value: pos,
                                onChanged: (val) {
                                  setState(() {
                                    pos = val;
                                  });
                                },
                                title: Row(
                                  children: <Widget>[
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/projectflutter-9b7b1.appspot.com/o/cms%2Fpos.png?alt=media&token=3b58917e-2afe-4e37-87ed-e72c1595a4c1',
                                          fit: BoxFit.fill),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'POS',
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
                              CheckboxListTile(
                                value: sicepat,
                                onChanged: (val) {
                                  setState(() {
                                    sicepat = val;
                                  });
                                },
                                title: Row(
                                  children: <Widget>[
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/projectflutter-9b7b1.appspot.com/o/cms%2Fsicepat.jpeg?alt=media&token=64c07834-1333-4b9b-8349-29444445ca18',
                                          fit: BoxFit.fill),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'SICEPAT',
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
                              CheckboxListTile(
                                value: tiki,
                                onChanged: (val) {
                                  setState(() {
                                    tiki = val;
                                  });
                                },
                                title: Row(
                                  children: <Widget>[
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: Image.network(
                                        'https://firebasestorage.googleapis.com/v0/b/projectflutter-9b7b1.appspot.com/o/cms%2Ftiki.jpeg?alt=media&token=46d6ba10-eb0d-413e-aa1e-820e6d0d1dff',
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
                            ],
                          )),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        if (await handleSubmit() == true) {
                          widget._key.currentState.showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('perubahan berhasil disimpan'),
                            ),
                          );
                        }
                      },
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
