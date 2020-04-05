class ProductModel {
  var key;
  var berat;
  var category;
  var comment;
  var coret;
  var deskripsi;
  var discount;
  var harga;
  var images;
  var kota;
  var merchant;
  var name;
  var originId;
  var originType;
  var priority;
  var rating;
  var sku;
  var unit;
  var update;
  var record;

  ProductModel({
    this.key,
    this.berat,
    this.category,
    this.comment,
    this.coret,
    this.deskripsi,
    this.discount,
    this.harga,
    this.images,
    this.kota,
    this.merchant,
    this.name,
    this.originId,
    this.originType,
    this.priority,
    this.rating,
    this.sku,
    this.unit,
    this.update,
    this.record,
  });

  factory ProductModel.fromSnapshot(key, data) {
    return ProductModel(
      key: key,
      berat: data["Berat"],
      category: data["Category"].replaceAll(new RegExp(r'[^\w\s]+'), ''),
      comment: data["Comment"],
      coret: data["Coret"],
      deskripsi: data["Deskripsi"].replaceAll(new RegExp(r'[^\w\s]+'), ''),
      discount: data["Discount"],
      harga: int.parse(data["Harga"]),
      images: data["Image"],
      kota: data["Kota"].replaceAll(new RegExp(r'[^\w\s]+'), ''),
      merchant: data["Merchant"].replaceAll(new RegExp(r'[^\w\s]+'), ''),
      name: data["Name"].replaceAll(new RegExp(r'[^\w\s]+'), ''),
      originId: data["OriginID"],
      originType: data["OriginType"],
      priority: data["Priority"],
      rating: data["Rating"],
      sku: data["SKU"],
      unit: data["Unit"],
      update: data["Update"],
      record: data["record"].replaceAll(new RegExp(r'[^\w\s]+'), ''),
    );
  }
}
