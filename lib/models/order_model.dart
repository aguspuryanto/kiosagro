class OrderModel {
  var key;
  var alamat;
  var buyer_id;
  var buyer_name;
  var gross_amount;
  var item_details;
  var seller_id;
  var seller_name;
  var status;
  var telepon;
  var unique;

  OrderModel({
    this.key,
    this.alamat,
    this.buyer_id,
    this.buyer_name,
    this.gross_amount,
    this.item_details,
    this.seller_id,
    this.seller_name,
    this.status,
    this.telepon,
    this.unique,
  });

  factory OrderModel.fromSnapshot(key, data) {
    return OrderModel(
      key: key,
      alamat: data["alamat"],
      buyer_id: data["buyer_id"],
      buyer_name: data["buyer_name"],
      gross_amount: data["gross_amount"],
      item_details: data["item_details"],
      seller_id: data["seller_id"],
      seller_name: data["seller_name"],
      status: data["status"],
      telepon: data["telepon"],
      unique: data["unique"],
    );
  }
}
