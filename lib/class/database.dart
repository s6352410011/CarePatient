import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<Stream<QuerySnapshot>> getUserdataDetail() async {
    return await FirebaseFirestore.instance.collection("general").snapshots();
  }
}
