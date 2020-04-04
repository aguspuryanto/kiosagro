class RequestModel {
  var key;
  var amount;
  var type;
  var uid;

  RequestModel({this.key, this.amount, this.type, this.uid});

  factory RequestModel.fromSnapshot(key, data) {
    return RequestModel(
      key: key,
      amount: data["amount"],
      type: data['type'],
      uid: data['uid'],
    );
  }
}
