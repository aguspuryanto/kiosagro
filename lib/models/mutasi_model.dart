class MutasiModel {
  var key;
  var amount;
  var balance;
  var note;
  var order;
  var type;
  var uid;

  MutasiModel({
    this.key,
    this.amount,
    this.balance,
    this.note,
    this.order,
    this.type,
    this.uid,
  });

  factory MutasiModel.fromSnapshot(key, data) {
    return MutasiModel(
      key: key,
      amount: data["amount"],
      balance: data["balance"],
      note: data["note"],
      order: data["order"],
      type: data["type"],
      uid: data["uid"],
    );
  }
}
