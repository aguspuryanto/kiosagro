import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StorageModel extends ChangeNotifier {
  void getImage(id) async {
    final QuerySnapshot result =
        await Firestore.instance.collection('products').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((doc) {
      print(doc);
    });
  }
}
