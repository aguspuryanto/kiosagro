class UserModel {
  var key;
  var alamat;
  var balance;
  var bank;
  var email;
  var holder;
  var membership;
  var mutasi;
  var nama;
  var namatoko;
  var orders;
  var pengiriman;
  var player_id;
  var products;
  var rating;
  var rekening;
  var subscribe;
  var surname;
  var telepon;
  var urltoko;
  var verifyshop;

  static const defaultAlamat = {
    'alamat': 'Jl. Salak RT002/RW019',
    'kabupaten': 'Cilacap',
    'kecamatan': 'Konoha',
    'provinsi': 'Jawa Tengah'
  };

  UserModel({
    this.key,
    this.alamat = defaultAlamat,
    this.balance,
    this.bank,
    this.email,
    this.holder,
    this.membership,
    this.mutasi,
    this.nama,
    this.namatoko,
    this.orders,
    this.pengiriman,
    this.player_id,
    this.products,
    this.rating,
    this.rekening,
    this.subscribe,
    this.surname,
    this.telepon,
    this.urltoko,
    this.verifyshop,
  });

  factory UserModel.fromSnapshot(key, data) {
    return UserModel(
      key: key,
      alamat: data['alamat'],
      balance: data['balance'],
      bank: data['bank'],
      email: data['email'],
      holder: data['holder'],
      membership: data['membership'],
      mutasi: data['mutasi'],
      nama: data['nama'].replaceAll(new RegExp(r'[^\w\s]+'), ''),
      namatoko: data['namatoko'].replaceAll(new RegExp(r'[^\w\s]+'), ''),
      orders: data['orders'],
      pengiriman: data['pengiriman'],
      player_id: data['player_id'],
      products: data['products'],
      rating: data['rating'],
      rekening: data['rekening'],
      subscribe: data['subscribe'],
      surname: data['surname'],
      telepon: data['telepon'],
      urltoko: data['urltoko'],
      verifyshop: data['verifyshop'],
    );
  }
}
