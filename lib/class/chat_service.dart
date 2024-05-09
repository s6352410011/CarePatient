import 'package:care_patient/class/message.dart';
import 'package:care_patient/class/user_data.dart';
import 'package:care_patient/login_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("caregiver").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

    Stream<List<Map<String, dynamic>>> getUserStream2() {
    return _firestore.collection("patient").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }



  // Stream<List<Map<String, dynamic>>> getUserStream() {
  //   if (LoginUI.selectedOption == 1) { // เรียกใช้ selectedOption จาก LoginUI
  //     return _firestore.collection("patient").snapshots().map((snapshot) {
  //       return snapshot.docs.map((doc) {
  //         final user = doc.data();
  //         return user;
  //       }).toList();
  //     });
  //   } else {
  //     return _firestore.collection("caregiver").snapshots().map((snapshot) {
  //       return snapshot.docs.map((doc) {
  //         final user = doc.data();
  //         return user;
  //       }).toList();
  //     });
  //   }
  // }



  Future<void> sendMessage(Stream<String> receiverIDStream, String message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // ฟังก์ชันการฟังเพื่อรับค่า receiverID จาก receiverIDStream และส่งข้อความ
    receiverIDStream.listen((receiverID) async {
      Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp,
      );

      List<String> ids = [currentUserID, receiverID];
      ids.sort();
      String chatRoomID = ids.join('_');

      await _firestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages")
          .add(newMessage.toMap());
    });
  }

  Stream<QuerySnapshot> getMessage(String userID, otherUserID) {
    final String currentUserID = _auth.currentUser!.uid;
    List<String> ids = [currentUserID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
