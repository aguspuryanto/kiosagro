class RatingModel {
  var keyProduct;
  var key;
  var comment;
  var star;

  RatingModel({this.keyProduct, this.key, this.comment, this.star});

  factory RatingModel.fromSnapshot(key, data) {
    return RatingModel(
      keyProduct: key,
      key: data["key"]["comment"],
      comment: data['key']['comment'],
    );
  }
}
